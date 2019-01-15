//
//  Loveday.swift
//  Practica 3
//
//  Created by g820 DIT UPM on 30/10/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

class Loveday: UIViewController {

    @IBOutlet weak var LovedayPickerDate: UIDatePicker!
    var birthday : Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        LovedayPickerDate.minimumDate = birthday
        LovedayPickerDate.maximumDate = Date()
        let userDefaults = UserDefaults.standard
        if((userDefaults.object(forKey: "Loveday")) != nil){
        LovedayPickerDate.date = userDefaults.object(forKey: "Loveday") as! Date
        // Do any additional setup after loading the view.
        }}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func OkButtonPressed(_ sender: UIButton) {
        let loveday = LovedayPickerDate.date
        let interval = loveday.timeIntervalSince(birthday!)
        ViewController.PartyDate = LovedayPickerDate.date.addingTimeInterval(interval)
        let userDefaults = UserDefaults.standard
        userDefaults.set(LovedayPickerDate.date, forKey: "Loveday")
        performSegue(withIdentifier: "UnwindSegueMain", sender: self)
    }

    @IBAction func CancelButtonPressed(_ sender: UIButton) {
    }
}
