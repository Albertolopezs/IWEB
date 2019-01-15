//
//  ViewController.swift
//  Practica 2
//
//  Created by g820 DIT UPM on 19/9/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit


class ViewController: UIViewController, FunctionViewDataSource {

    var cubeModel: CubeModel!
    
    
    @IBOutlet weak var PosTimeFunctionView: DrawGraphic!
    @IBOutlet weak var speedTimeFunctionView: DrawGraphic!
    @IBOutlet weak var acelTimeFunctionView: DrawGraphic!
    @IBOutlet weak var speedPosFunctionView: DrawGraphic!
    @IBOutlet weak var AristSizeSlider: UISlider!
    @IBOutlet weak var POISlider: UISlider!
    @IBOutlet weak var AristSizeLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    var multiplicador : Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cubeModel = CubeModel()
        speedPosFunctionView.dataSource = self
        PosTimeFunctionView.dataSource = self
        speedTimeFunctionView.dataSource = self
        acelTimeFunctionView.dataSource = self

        
        speedPosFunctionView.scaleX = 10.0
        speedPosFunctionView.scaleY = 20.0
        speedPosFunctionView.trajectoryColor  = UIColor.blue
        
        PosTimeFunctionView.scaleX = 20.0
        PosTimeFunctionView.scaleY = 13
        PosTimeFunctionView.trajectoryColor  = UIColor.blue
        
        speedTimeFunctionView.scaleX = 20.0
        speedTimeFunctionView.scaleY = 6.0
        speedTimeFunctionView.trajectoryColor  = UIColor.red
        
        acelTimeFunctionView.scaleX = 20.0
        acelTimeFunctionView.scaleY = 4.0
        acelTimeFunctionView.trajectoryColor  = UIColor.brown
        AristSizeLabel.text = String(3.0)
        TimeLabel.text = String(5.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshAristSize(_ sender: UISlider) {
        let multiplicador = sender.value
        let arista = max(multiplicador,0.1)
        AristSizeLabel.text = String(round(100*arista)/100)
        cubeModel.aristSize = Double(arista)
        speedPosFunctionView.setNeedsDisplay()
        PosTimeFunctionView.setNeedsDisplay()
        speedTimeFunctionView.setNeedsDisplay()
        acelTimeFunctionView.setNeedsDisplay()
    }
    @IBAction func pinchScale(_ sender: UIPinchGestureRecognizer) {
        speedPosFunctionView.scaleX *= Double(sender.scale)
        PosTimeFunctionView.scaleX *= Double(sender.scale)
        speedTimeFunctionView.scaleX *= Double(sender.scale)
        acelTimeFunctionView.scaleX *= Double(sender.scale)
        sender.scale = 1
        
    }
    @IBAction func tapScale(_ sender: UITapGestureRecognizer) {
        speedPosFunctionView.scaleY *= 1.2
        PosTimeFunctionView.scaleY *= 1.2
        speedTimeFunctionView.scaleY *= 1.2
        acelTimeFunctionView.scaleY *= 1.2
        
    }
    @IBAction func refreshPOI(_ sender: UISlider) {
        let multiplicador = sender.value
        TimeLabel.text = String(round(100*multiplicador)/100)
        DrawGraphic.timePoint = Double(multiplicador)
        speedPosFunctionView.setNeedsDisplay()
        PosTimeFunctionView.setNeedsDisplay()
        speedTimeFunctionView.setNeedsDisplay()
        acelTimeFunctionView.setNeedsDisplay()
    }
    func startTimeOfFunctionView(_ functionView: DrawGraphic) -> Double {return 0.0}
    func endTimeOfFunctionView(_ functionView: DrawGraphic) -> Double {return 100}
    func POIFunctionView(_ functionView: DrawGraphic, atTime time: Double) -> Point{
        switch functionView {
        case PosTimeFunctionView:
            let x = time
            let y = cubeModel.posAtTime(time)
            PosTimeFunctionView.value = String(round(y*100)/100) + " m"
            return Point(x:x, y:y)
        case speedTimeFunctionView:
            let x = time
            let y = cubeModel.speedAtTime(time)
            speedTimeFunctionView.value = String(round(y*100)/100) + " m/s"
            return Point(x:x, y:y)
        case acelTimeFunctionView:
            let x = time
            let y = cubeModel.acelAtTime(time)
            acelTimeFunctionView.value = String(round(y*100)/100) + " m/(s^2)"
            return Point(x:x, y:y)
        case speedPosFunctionView:
            let y = cubeModel.posAtTime(time)
            let x = cubeModel.speedAtTime(time)
            speedPosFunctionView.value = String(round(y*100)/100) + " m"
            return Point(x:x, y:y)
        default:
            return Point(x:0.0, y:0.0)
        }
    }
}

