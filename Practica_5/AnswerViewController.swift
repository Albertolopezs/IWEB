//
//  AnswerViewController.swift
//  Practica 5
//
//  Created by Chema on 23/11/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit



class AnswerViewController: UIViewController{

    
    
    @IBOutlet weak var AnswerOutlet: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var QuestionLAbel: UILabel!
    @IBOutlet weak var TextField: UITextField!
    var question : String?
    var id: Int = 1
    var urlImage : String?
    var urlRequestbase = "https://quiz2019.herokuapp.com/api/quizzes/"
    var token = "&token=67b100496ccef9b63860"
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFields()
        AnswerOutlet.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func updateFields(){
        
        var queue = DispatchQueue(label: "image queue", attributes: [])
        queue.async {
            
            
            let data = try? Data(contentsOf: URL(string:self.urlImage!)!)
            
            DispatchQueue.main.async {
                // Mostrar indicador de actividad de red
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                
            }
            defer {
                DispatchQueue.main.async {
                    // Ocultar indicador de actividad de red
                    
                    self.ImageView?.image = UIImage(data: data!)
                    self.QuestionLAbel?.text = self.question
                    
                    //let total = dic["total"] as! Int
                    //cell.detailTextLabel?.text = "\(total)"
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    
                }
            }
    }
    }
    

    
    @IBAction func ComprobarAction(_ sender: UIButton) {
        let textEscaped = TextField.text!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
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
                        self.AnswerOutlet.text! = "Correcto"
                        self.AnswerOutlet.textColor = UIColor.green
                    }
                    else{
                        self.AnswerOutlet.text! = "Incorrecto"
                        self.AnswerOutlet.textColor = UIColor.red
                    }
                    
                    //let total = dic["total"] as! Int
                    //cell.detailTextLabel?.text = "\(total)"
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                    
                }
            }
    }
    }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
