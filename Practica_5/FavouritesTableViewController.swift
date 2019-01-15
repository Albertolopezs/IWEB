//
//  FavouritesTableViewController.swift
//  Practica 5
//
//  Created by Chema on 24/11/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
    var URLString : String = "https://quiz2019.herokuapp.com/api/quizzes?token=67b100496ccef9b63860"
    var quizarray : [quizStruct] = []
    var nextUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func downloadJSON(){
        var quizzesTotales : [String:Any]??
        var queue = DispatchQueue(label: "cell queue", attributes: [])
        queue.async {
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
                            quizstruct.favourite = quizf.value(forKey: "favourite")  as? Bool
                            print(quizstruct.favourite)
                            if(quizstruct.favourite)!{
                                self.quizarray.append(quizstruct)
                            }
                            
                        }
                        print(self.quizarray)
                        if(self.nextUrl != ""){
                            self.URLString = self.nextUrl
                            self.downloadJSON()
                        }
                        
                    }
                    
                    
                }
                catch{
                    print(error)
                }
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
            
                }
            }
        }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizarray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "quiz favorito", for: indexPath) as! CellTableViewCell
        
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
                    if( self.quizarray[indexPath.row].favourite)!{
                        cell.FavouriteOutlet.setImage(#imageLiteral(resourceName: "Webp.net-resizeimage.png"), for:.normal)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
