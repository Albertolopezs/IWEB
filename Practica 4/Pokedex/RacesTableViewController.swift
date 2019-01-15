//
//  RacesTableViewController.swift
//  Pokedex
//
//  Created by Daniel Lledó on 06/11/2018.
//  Copyright © 2018 JorgeTardio. All rights reserved.
//

import UIKit

class RacesTableViewController: UITableViewController {
    
    var type: Type?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Guardando en la variable title: automaticamente guarda el nombre del tipo en el nav controller
        title = type?.name

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return type?.races.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let race = type!.races[indexPath.row]
        let raceCell = tableView.dequeueReusableCell(withIdentifier: "raceCell", for: indexPath)
        
        raceCell.textLabel?.text = race.name
        raceCell.detailTextLabel?.text = "\(race.code)"
        raceCell.detailTextLabel?.textColor = .red
        raceCell.imageView?.image = UIImage(named: race.icon)
        
        return raceCell
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWeb"{
            let destination = segue.destination as! WebViewController
            if let indexCellSelected = tableView.indexPathForSelectedRow?.row{
                destination.race = type!.races[indexCellSelected]
            }
        }
    }

}
