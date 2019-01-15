//
//  10QuizRandomViewController.swift
//  Practica 5
//
//  Created by Chema on 24/11/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

class TenQuizRandomViewController: UIViewController {

    @IBOutlet weak var ImageViewOutlet: UIImageView!
    @IBOutlet weak var QuestionOutlet: UILabel!
    @IBOutlet weak var TextFieldOutlet: UITextField!
    @IBOutlet weak var ScoreOutlet: UILabel!
    var contador : Int = 0
    var id = 0
    var URLString : String = "https://quiz2019.herokuapp.com/api/quizzes/random10wa?token=67b100496ccef9b63860"
    var quizarray : [quizStruct] = []
    var urlRequestbase = "https://quiz2019.herokuapp.com/api/quizzes/"
    var token = "&token=67b100496ccef9b63860"
    var score : Int = 0
    var terminar : Bool = false
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
        self.id = (quizarray[self.contador].id as? Int)!
        let textEscaped = TextFieldOutlet.text!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url :String = self.urlRequestbase + String(self.id) + "/check?answer=" + textEscaped! + token
        
        var queue = DispatchQueue(label: "answer queue", attributes: [])
        var result : Bool?
        if(self.contador < quizarray.count-2){
            self.contador += 1
        }
        else{
            self.terminar = true
        }

        queue.async {
            
            let dataImage = try? Data(contentsOf: URL(string:(self.quizarray[self.contador].attachment?.value(forKey: "url") as? String)!)!)

            
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
                            if(self.terminar){
                                self.score += 1
                                self.ScoreOutlet.text! = "Tu puntuación final es de " + String(self.score) + " puntos"
                            }
                            else{
                            self.score += 1
                            self.ScoreOutlet.text! = "Tu puntuación: " + String(self.score)
                            }
                        }
                        else{
                            if(self.terminar){
                            self.ScoreOutlet.text! = "Tu puntuación final es de " + String(self.score) + " puntos"
                            }
                            else{
                                self.ScoreOutlet.text! = "Tu puntuación: " + String(self.score)
                            }
                        }
                        self.QuestionOutlet?.text = self.quizarray[self.contador].question
                        self.ImageViewOutlet.image = UIImage(data: dataImage!)
                        //let total = dic["total"] as! Int
                        //cell.detailTextLabel?.text = "\(total)"
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        return
                        
                        }
                }
            }
            
        }
        
    }
    
    
    fileprivate func downloadJSON(){
        var quizzesTotales : [String:Any]??
        var queue = DispatchQueue(label: "download queue", attributes: [])
        queue.async {            if let data = try? Data(contentsOf: URL(string:self.URLString)!){
                let str: String? = String(data:data, encoding: String.Encoding.utf8)
                
                do{
                    let quizzjson = try JSONSerialization.jsonObject(with: data, options: [])
                    //quizzes totales obtiene el JSON con las tres partes, quizzes, pageno y nextUrl
                    
                    if let quizzesTotales = quizzjson as? NSArray{
                        //print(quizzesTotales)
                        for quiz in quizzesTotales{
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
                            self.quizarray.append(quizstruct)
                            
                        }
                        
                        
                      
                        
                    }
                    
                    
                }
                catch{
                    print(error)
                }
            }
            let dataImage = try? Data(contentsOf: URL(string:(self.quizarray[self.contador].attachment?.value(forKey: "url") as? String)!)!)

            // El GUI se actualiza en el Main Thread
            
            DispatchQueue.main.async {
                // Mostrar indicador de actividad de red
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            defer {
                DispatchQueue.main.async {
                    // Ocultar indicador de actividad de red
                    print(self.quizarray)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    print(1)
                    self.QuestionOutlet?.text = self.quizarray[self.contador].question
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
