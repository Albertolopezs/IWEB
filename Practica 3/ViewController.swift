//
//  ViewController.swift
//  Practica 3
//
//  Created by g820 DIT UPM on 30/10/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static var PartyDate : Date?
    
    @IBOutlet weak var DateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        DateLabel.text = "No la has calculado"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        if((ViewController.PartyDate) != nil){
            
        DateLabel.text = df.string(for: ViewController.PartyDate)
    }}

}

