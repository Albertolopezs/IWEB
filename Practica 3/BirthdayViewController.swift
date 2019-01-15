//
//  BirthdayViewController.swift
//  Practica 3
//
//  Created by g820 DIT UPM on 30/10/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController {

    @IBOutlet weak var BirthdayDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        BirthdayDatePicker.maximumDate = Date()
        let userDefaults = UserDefaults.standard
        if((userDefaults.object(forKey: "Birthday")) != nil){
        BirthdayDatePicker.date = userDefaults.object(forKey: "Birthday") as! Date
        // Do any additional setup after loading the view.
    }}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segundosegue" {
            if let viewController = segue.destination as? Loveday {
                let userDefaults = UserDefaults.standard
                userDefaults.set(BirthdayDatePicker.date, forKey: "Birthday")
                viewController.birthday = BirthdayDatePicker.date
            }
        }
    }
    @IBAction func CancelButtonPressed(_ sender: UIButton) {
    }
}
