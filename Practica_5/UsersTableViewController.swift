//
//  UsersTableViewController.swift
//  Practica 5
//
//  Created by Chema on 24/11/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

struct AuthorStruct{
    var id : Int?
    var isAdmin : Bool?
    var username : String?
}
class UsersTableViewController: UITableViewController {

    
    var authorarray : [AuthorStruct] = []
    var URLString : String = "https://quiz2019.herokuapp.com/api/users?token=67b100496ccef9b63860"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadJSON()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    fileprivate func downloadJSON(){
        var queue = DispatchQueue(label: "cell queue", attributes: [])
        queue.async {
            
            if let data = try? Data(contentsOf: URL(string:self.URLString)!){
                print(1)
                do{
                    let authorjson = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let AuthoresTotales = authorjson as? NSArray{
                        
                        
                        for author in AuthoresTotales{
                            var authorstruct = AuthorStruct()
                            let authorf = author as! NSDictionary
                            let isAdmin = authorf.value(forKey: "isAdmin") as? Bool
                            let id = authorf.value(forKey: "id") as? Int
                            var username = authorf.value(forKey: "username") as? String
                            
                            authorstruct.id = id
                            authorstruct.isAdmin = isAdmin
                            authorstruct.username = username
                            self.authorarray.append(authorstruct)
                            
                            
                        }
                        print(self.authorarray)
                        
                    }
                }
                catch{
                    print(error)
                }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return authorarray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Author Cell", for: indexPath)

        cell.textLabel?.text = authorarray[indexPath.row].username
        if (authorarray[indexPath.row].isAdmin) == nil{
            cell.detailTextLabel?.text = "No administrador"
        }
        else{
            if authorarray[indexPath.row].isAdmin == false{
            cell.detailTextLabel?.text = "No administrador"
            }
            else{
            cell.detailTextLabel?.text = "Administrador"
            }
            }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show User Quiz" {
            
            // sender es la celda de la tabla que disparo el segue.
            if let avc = segue.destination as? UserQuizTableViewController,
                let cell = sender as? UITableViewCell,
                let ip = tableView.indexPath(for: cell) {
                
                avc.id = (self.authorarray[ip.row].id)!
                print(self.authorarray[ip.row].id)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    */

}
