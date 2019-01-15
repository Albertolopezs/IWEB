//
//  QuizRandomViewController.swift
//  Practica 5
//
//  Created by Chema on 24/11/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

class QuizRandomViewController: UIViewController {

    @IBOutlet weak var ImageOutlet: UIImageView!
    @IBOutlet weak var TextFieldOutlet: UITextField!
    @IBOutlet weak var questionOutlet: UILabel!
    @IBOutlet weak var ResultOutlet: UILabel!
    var id : Int = 1
    let URLString = "https://quiz2019.herokuapp.com/api/quizzes/random?token=67b100496ccef9b63860"
    var urlRequestbase = "https://quiz2019.herokuapp.com/api/quizzes/"
    var token = "&token=67b100496ccef9b63860"
    var quizstruct = quizStruct()
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJSON()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ComprobarAction(_ sender: UIButton) {
        self.id = (quizstruct.id as? Int)!
        let textEscaped = TextFieldOutlet.text!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url :String = self.urlRequestbase + String(self.id) + "/check?answer=" + textEscaped! + token
        
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
                        
                        if (result)!{
                            self.ResultOutlet.text! = "Correcto"
                            self.ResultOutlet.textColor = UIColor.green
                        }
                        else{
                            self.ResultOutlet.text! = "Incorrecto"
                            self.ResultOutlet.textColor = UIColor.red
                        }
                        
                        //let total = dic["total"] as! Int
                        //cell.detailTextLabel?.text = "\(total)"
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        return
                        
                    }
                }
            }}}
        
    
    fileprivate func downloadJSON(){
        var quizzesTotales : [String:Any]??
        var queue = DispatchQueue(label: "download queue", attributes: [])
        queue.async {
            
            if let data = try? Data(contentsOf: URL(string:self.URLString)!){
                let str: String? = String(data:data, encoding: String.Encoding.utf8)
                
                do{
                    let quizzjson = try JSONSerialization.jsonObject(with: data, options: [])
                    //quizzes totales obtiene el JSON con las tres partes, quizzes, pageno y nextUrl
                    
                    if let quizf = quizzjson as? NSDictionary{
                        //print(quizzesTotales)
                        
                        
                        let question = quizf.value(forKey: "question") as! String
                        let id = quizf.value(forKey: "id") as! NSNumber
                        var quizauthor = quizf.value(forKey: "author") as! NSObject
                        var quizauthor2: NSDictionary?
                        if(quizauthor.isKind(of: NSNull.self)){
                            quizauthor2 = ["username" : "Anonymous"]
                        }
                        else{
                            quizauthor2 = quizauthor as? NSDictionary}
                        
                        let tip  = quizf.value(forKey: "tip") as? [String]
                        let attachment = quizf.value(forKey: "attachment") as? NSDictionary
                        self.quizstruct.question = question
                        self.quizstruct.id = id
                        self.quizstruct.author = quizauthor2
                        self.quizstruct.tip = tip
                        self.quizstruct.attachment = attachment
                        
                    }
                    
                    
                    
                    
                    
                }
                catch{
                    print(error)
                }
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
                    self.questionOutlet.text = self.quizstruct.question!
                    self.ImageOutlet.image = UIImage(data: dataImage!)
                }
                
 
        }}

}
}
