//
//  MenuViewController.swift
//  Practica 5
//
//  Created by Chema on 23/11/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit
import SystemConfiguration

class MenuViewController: UIViewController {

    @IBOutlet weak var scoreOutlet: UILabel!
    let defaultuser = UserDefaults.standard
    
    let reachability = SCNetworkReachabilityCreateWithName(nil, "https://quiz2019.herokuapp.com")
    var flags = SCNetworkReachabilityFlags()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if(userDefaults.integer(forKey: "score")) != nil{
            scoreOutlet.text = String(userDefaults.integer(forKey: "score"))
        }
        else{
            scoreOutlet.text = "0"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        SCNetworkReachabilityGetFlags(reachability!, &self.flags)
        let isReachable: Bool = flags.contains(.reachable)
        if isReachable{
            return true
        }else{
            let alert = UIAlertController(title: "Network Error", message: "No se puede jugar sin conexión a internet", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default))
            present(alert, animated:true)
            return false
        }
    }

}
