//
//  AllTableViewController.swift
//  Practica 5
//
//  Created by g820 DIT UPM on 19/11/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

struct quizStruct {
    var question : String?
    var id : NSNumber?
    var author : NSDictionary?
    var tip : [String]?
    var attachment : NSDictionary?
    var favourite : Bool?
}

class AllTableViewController: UITableViewController {

    
    // Los datos descargados:
    var quizarray : [quizStruct] = []

    
    
    // La session
    var session: URLSession!
    var URLString : String = "https://quiz2019.herokuapp.com/api/quizzes?token=67b100496ccef9b63860"
    var nextUrl : String = ""
    let token = "?token=67b100496ccef9b63860"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        downloadJSON()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    fileprivate func downloadJSON(){
        var quizzesTotales : [String:Any]??
        var queue = DispatchQueue(label: "cell queue", attributes: [])
        queue.async {
            
            // El GUI se actualiza en el Main Thread
        
            DispatchQueue.main.async {
                // Mostrar indicador de actividad de red
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            defer {
                DispatchQueue.main.async {
                    // Ocultar indicador de actividad de red 
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }
                
                if let data = try? Data(contentsOf: URL(string:self.URLString)!){
               
                    do{
                        let quizzjson = try JSONSerialization.jsonObject(with: data, options: [])
                        //quizzes totales obtiene el JSON con las tres partes, quizzes, pageno y nextUrl
                        
                        if let quizzesTotales = quizzjson as? [String:Any]{
                            //print(quizzesTotales)
                            let quizs = quizzesTotales["quizzes"] as? NSArray
                            self.nextUrl = (quizzesTotales["nextUrl"] as? String)!
                            for quiz in quizs!{
                                var quizstruct = quizStruct()
                                let quizf = quiz as! NSDictionary
                                let question = quizf.value(forKey: "question") as! String
                                let id = quizf.value(forKey: "id") as! NSNumber
                                var quizauthor = quizf.value(forKey: "author") as! NSObject
                                var quizauthor2: NSDictionary?
                                if(quizauthor.isKind(of: NSNull.self)){
                                     quizauthor2 = ["username" : "Anonymous"]
                                    
                                }
                                else{
                                    quizauthor2 = quizauthor as? NSDictionary                                 }
                                let tip  = quizf.value(forKey: "tip") as? [String]
                                let attachment = quizf.value(forKey: "attachment") as? NSDictionary
                                quizstruct.question = question
                                quizstruct.id = id
                                quizstruct.author = quizauthor2
                                quizstruct.tip = tip
                                quizstruct.attachment = attachment
                                quizstruct.favourite = quizf.value(forKey: "favourite") as? Bool
                                self.quizarray.append(quizstruct)
                            }
                            if(self.nextUrl != ""){
                                self.URLString = self.nextUrl
                                self.downloadJSON()
                            }
                        
                        }
                       
                        
                        }
                    catch{
                        print(error)
                    }
            }
        }
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizarray.count
    }

    @IBAction func FavouriteButton(_ sender: UIButton?) {
        guard let cell = sender?.superview?.superview as? CellTableViewCell else {
            return // or fatalError() or whatever
        }
        
        let ip = tableView.indexPath(for: cell)
        
            //Si la quiz es favorita ya
            if(quizarray[(ip?.row)!].favourite)!{
                let id = self.quizarray[(ip?.row)!].id as! Int
                guard let url = URL(string: "https://quiz2019.herokuapp.com/api/users/tokenOwner/favourites/" + String(id)
                    + self.token) else { return }
                print("https://quiz2019.herokuapp.com/api/users/tokenOwner/favourites/" + "\(String(describing: self.quizarray[(ip?.row)!].id))" + self.token)
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                
                //--- La sesion:
                let sessionConf = URLSessionConfiguration.ephemeral
                let session = URLSession(configuration: sessionConf)
                
                    //--- La tarea para subir los datos:
                let datatask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                        // El completionHandler no corre en el Main Thread
                        DispatchQueue.main.async {
        
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    let code = (response as! HTTPURLResponse).statusCode
                    print(code)
                    if code == 200 {
                        print("Enviado")
                        DispatchQueue.main.async {
                            self.quizarray[(ip?.row)!].favourite = false
                            sender?.setImage(UIImage(named: "1024px-Empty_Star.svg"), for: .normal)
                            self.tableView.reloadData()
                        }
                    }}
                    datatask.resume()
                

            }
                //Si no lo es
            else{
                let id = self.quizarray[(ip?.row)!].id as! Int
                    guard let url = URL(string: "https://quiz2019.herokuapp.com/api/users/tokenOwner/favourites/" + String(id)
                        + self.token) else { return }
                    var request = URLRequest(url: url)
                print(id)
                    request.httpMethod = "PUT"
                    request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    
                    //--- La sesion:
                    let sessionConf = URLSessionConfiguration.ephemeral
                    let session = URLSession(configuration: sessionConf)
                    
                    //--- La tarea para subir los datos:
                    let datatask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                        // El completionHandler no corre en el Main Thread
                        DispatchQueue.main.async {
                            
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                        let code = (response as! HTTPURLResponse).statusCode
                        print(code)
                        if code == 200 {
                            print("Enviado")
                            DispatchQueue.main.async {
                                self.quizarray[(ip?.row)!].favourite = true
                                 sender?.setImage(UIImage(named: "Gold_Star.svg"), for: .normal)
                                    self.tableView.reloadData()
                            }
                        }}
                        datatask.resume()
                    
                    
                
            }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quiz", for: indexPath) as! CellTableViewCell
       
        // let dic = quizzes[indexPath.row]
        
        var queue = DispatchQueue(label: "image queue", attributes: [])
        queue.async {
            
            let urlImage = self.quizarray[indexPath.row].attachment?.value(forKey: "url") as? String
            let data = try? Data(contentsOf: URL(string:urlImage!)!)

            DispatchQueue.main.async {
                // Mostrar indicador de actividad de red
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                
            }
            defer {
                DispatchQueue.main.async {
                    // Ocultar indicador de actividad de red
                    
                    cell.Imageview?.image = UIImage(data: data!)
                    cell.Imageview?.contentMode = .scaleAspectFit
                    if( self.quizarray[indexPath.row].favourite)!{
                        cell.FavouriteOutlet.imageView?.image = UIImage(named: "Gold_Star.svg")
                    }
                    else{
                        
                        cell.FavouriteOutlet.imageView?.image = UIImage(named: "1024px-Empty_Star.svg")
                    }
                    cell.TituloLabel?.text = self.quizarray[indexPath.row].question
                    cell.AuthorLabel?.text = self.quizarray[indexPath.row].author?.value(forKey: "username") as? String
                    //let total = dic["total"] as! Int
                    //cell.detailTextLabel?.text = "\(total)"
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    

                }
            }
        
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Cell Quiz" {
            
            // sender es la celda de la tabla que disparo el segue.
            if let avc = segue.destination as? AnswerViewController,
                let cell = sender as? UITableViewCell,
                let ip = tableView.indexPath(for: cell) {
                
                avc.question = self.quizarray[ip.row].question
                avc.id = (self.quizarray[ip.row].id as? Int)!
                avc.urlImage = self.quizarray[ip.row].attachment?.value(forKey: "url") as? String
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */



    


}
