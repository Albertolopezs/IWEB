//
//  PlayRandomViewController.swift
//  Practica 5
//
//  Created by Chema on 24/11/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

class PlayRandomViewController: UIViewController {

    @IBOutlet weak var ImageViewOutlet: UIImageView!
    @IBOutlet weak var TextFieldOutlet: UITextField!
    @IBOutlet weak var questionOutlet: UILabel!
    @IBOutlet weak var ResultOutlet: UILabel!
    var contador : Int = 0
    var id = 0

    var urlRequestbase = "https://quiz2019.herokuapp.com/api/quizzes/"
    var token = "&token=67b100496ccef9b63860"
    var score : Int = 0
    var terminar : Bool = false
    var quizstruct = quizStruct()

    var URLString = "https://quiz2019.herokuapp.com/api/quizzes/randomPlay/new?token=67b100496ccef9b63860"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadJSON()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ComprobarAction(_ sender: UIButton) {
        self.id = (quizstruct.id as? Int)!
        let textEscaped = TextFieldOutlet.text!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url :String = self.urlRequestbase + "randomPlay/check?answer=" + textEscaped! + token
        print(url)
        var queue = DispatchQueue(label: "answer queue", attributes: [])
        var result : Bool?
        
        queue.async {
            
            if let data = try? Data(contentsOf: URL(string:url)!){
                let str: String? = String(data:data, encoding: String.Encoding.utf8)
                
                do{
                    let quizzjson = try JSONSerialization.jsonObject(with: data, options: [])
                    if let quiz = quizzjson as? [String : Any]{
                        //print(quiz)
                        result = quiz["result"] as? Bool
                        self.score = (quiz["score"] as? Int)!
                        
                    }}
                catch{
                    print(error)
                }
                
                DispatchQueue.main.async {
                    // Mostrar indicador de actividad de red
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    
                    
                }
                defer {
                    DispatchQueue.main.async {
                        // Ocultar indicador de actividad de red
                        self.URLString = "https://quiz2019.herokuapp.com/api/quizzes/randomPlay/next?token=67b100496ccef9b63860"

                        if (result)!{
                            
                            self.ResultOutlet.text! = "Tu puntuación: " + String(self.score)
                            self.downloadJSON()
                               self.TextFieldOutlet.text = ""
                            }
                        else{
                                self.ResultOutlet.text! = "Tu puntuación final es de: " + String(self.score)
                            }
                            //let total = dic["total"] as! Int
                            //cell.detailTextLabel?.text = "\(total)"
                        let userDefaults = UserDefaults.standard
                        if(userDefaults.integer(forKey: "score") < self.score){
                        userDefaults.set(self.score, forKey: "score")
                        }
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            return
                            
                        }
                }
            }
            
        }
        
    }
    
    
    fileprivate func downloadJSON(){
        var queue = DispatchQueue(label: "download queue", attributes: [])
        
        queue.async {
            if let data = try? Data(contentsOf: URL(string:self.URLString)!){
            
            do{
                let quizzjson = try JSONSerialization.jsonObject(with: data, options: [])
                //quizzes totales obtiene el JSON con las tres partes, quizzes, pageno y nextUrl
                
                if let quizzesTotales = quizzjson as? NSDictionary{
                    let quizf = quizzesTotales["quiz"] as? NSDictionary
                    self.score = (quizzesTotales["score"] as? Int)!
                    //print(quizzesTotales)
                    
                    let question = quizf?.value(forKey: "question") as! String
                    let id = quizf?.value(forKey: "id") as! NSNumber
                    var quizauthor = quizf?.value(forKey: "author") as! NSObject
                    var quizauthor2: NSDictionary?
                    if(quizauthor.isKind(of: NSNull.self)){
                        quizauthor2 = ["username" : "Anonymous"]
                            
                    }
                    else{
                        quizauthor2 = quizauthor as? NSDictionary                                 }
                    let tip  = quizf?.value(forKey: "tip") as? [String]
                    let attachment = quizf?.value(forKey: "attachment") as? NSDictionary
                    self.quizstruct.question = question
                    self.quizstruct.id = id
                    self.quizstruct.author = quizauthor2
                    self.quizstruct.tip = tip
                    self.quizstruct.attachment = attachment
                        
                    }
                    print(0)
                    
                    
                    
                }
                
                
            
            catch{
                print(error)
            }
            
            let dataImage = try? Data(contentsOf: URL(string:(self.quizstruct.attachment?.value(forKey: "url") as? String)!)!)
            
            // El GUI se actualiza en el Main Thread
            
            DispatchQueue.main.async {
                // Mostrar indicador de actividad de red
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            defer {
                DispatchQueue.main.async {
                    // Ocultar indicador de actividad de red
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    print(1)
                    self.questionOutlet?.text = self.quizstruct.question
                    self.ImageViewOutlet.image = UIImage(data: dataImage!)
                    
                }
                
                
            }}}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
}
