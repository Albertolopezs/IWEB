//
//  WebViewController.swift
//  Pokedex
//
//  Created by JorgeTardio on 06/11/2018.
//  Copyright © 2018 JorgeTardio. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var race : Race?
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        title = race?.name
        let url = URL (string: "http://es.pokemon.wikia.com/wiki/"+race!.name);
        let requestObj = URLRequest(url: url!);
            webView.load(requestObj);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
