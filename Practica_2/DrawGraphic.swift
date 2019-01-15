//
//  DrawGraphic.swift
//  Practica 2
//
//  Created by g820 DIT UPM on 19/9/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import UIKit

struct Point {
    var x = 0.0
    var y = 0.0
}

protocol FunctionViewDataSource: class {
    
    func startTimeOfFunctionView(_ functionView: DrawGraphic) -> Double
    func endTimeOfFunctionView(_ functionView: DrawGraphic) -> Double
    func POIFunctionView(_ functionView: DrawGraphic, atTime time: Double) -> Point
}


class DrawGraphic: UIView {
    
    @IBInspectable
    var textX:String = "x"
    
    @IBInspectable
    var textY:String = "y"
    
    @IBInspectable
    var value:String = ""
    
    
    static var timePoint = 4.0
    let cubeModel = CubeModel()
    var trajectoryColor : UIColor!
    var lineWidth = 2.0
    var scaleX: Double! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Numero de puntos en el eje Y por unidad representada
    var scaleY: Double!  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Resolucion: Numero de muestras tomadas
    var resolution: Double = 2000 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    

    weak var dataSource: FunctionViewDataSource!
    

    override func draw(_ rect: CGRect) {
        drawAxis()
        drawTrajectory()
        drawPOI()
        drawTicks()
        drawTexts()
        
    }
    
    private func drawAxis() {
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: width/2, y: 0))
        path1.addLine(to: CGPoint(x: width/2, y: height))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: height/2))
        path2.addLine(to: CGPoint(x: width, y: height/2))
        
        UIColor.black.setStroke()
        
        path1.lineWidth = 1
        path1.stroke()
        path2.lineWidth = 1
        path2.stroke()
    }
    
    private func drawTrajectory() {
        trajectoryColor.set()
        
        let startTime = dataSource.startTimeOfFunctionView(self)
        let endTime = dataSource.endTimeOfFunctionView(self)
        let incrTime = max((endTime - startTime) / resolution , 0.01)
        
        let path = UIBezierPath()
        path.lineWidth = CGFloat(lineWidth)
        var point = dataSource.POIFunctionView(self, atTime: startTime)
        
        var px = pointForX(point.x)
        
        var py = pointForY(point.y)
        path.move(to: CGPoint(x: px, y: py))
        
        for t in stride(from: startTime, to: endTime, by: incrTime) {
            point = dataSource.POIFunctionView(self, atTime: t)
            px = pointForX(point.x)
            py = pointForY(point.y)
            path.addLine(to: CGPoint(x: px, y: py))
        }
        path.stroke()
    }
    
    private func drawPOI(){
        let point = dataSource.POIFunctionView(self, atTime: DrawGraphic.timePoint)
        let px = pointForX(point.x)
        let py = pointForY(point.y)
        let path = UIBezierPath(ovalIn: CGRect(x: px-4, y: py-4, width: 6, height: 6))
        UIColor.gray.set()
        
        path.stroke()
        path.fill()
        
    }
    
    private func drawTicks() {
        
        let numberOfTicks = 8.0
        
        UIColor.blue.set()
        
        let ptsYByTick = Double(bounds.size.height) / numberOfTicks
        let unitsYByTick = round((ptsYByTick/scaleY)*10)/10
        for y in stride(from: -numberOfTicks * unitsYByTick, to: numberOfTicks*unitsYByTick, by: unitsYByTick) {
            let px = pointForX(0)
            let py = pointForY(y)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px-2, y: py))
            path.addLine(to: CGPoint(x: px+2, y: py))
            
            path.stroke()
        }
        
        let ptsXByTick = Double(bounds.size.width) / numberOfTicks
        let unitsXByTick = round((ptsXByTick/scaleY)*10)/10
        for x in stride(from: -numberOfTicks * unitsXByTick, to: numberOfTicks*unitsXByTick, by: unitsXByTick) {
            let px = pointForX(x)
            let py = pointForY(0)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px, y: py-2))
            path.addLine(to: CGPoint(x: px, y: py+2))
            
            path.stroke()
        }
    }
    
    private func drawTexts() {
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        let attrs = [NSAttributedString.Key.font: UIFont.init(name: "Charter", size: 12)]
        
        let offset: CGFloat = 4 // Separacion del texto al eje y al borde
        
        let asX = NSAttributedString(string: textX, attributes: attrs as [NSAttributedString.Key : Any])
        let sizeX = asX.size()
        let posX = CGPoint(x: width - sizeX.width - offset, y: height/2 + offset)
        asX.draw(at: posX)
        
        let asY = NSAttributedString(string: textY, attributes: attrs as [NSAttributedString.Key : Any])
        let posY = CGPoint(x: width/2 + offset, y: offset)
        asY.draw(at: posY)
        
        
        _ = NSAttributedString(string: value, attributes: attrs as [NSAttributedString.Key : Any])
        let posvalue = CGPoint(x: 10 + offset, y: 10)
        value.draw(at: posvalue)
    }
    
    private func pointForX(_ x: Double) -> CGFloat {
        let width = bounds.size.width
        return width/2 + CGFloat(x*scaleX)
    }
    
    private func pointForY(_ y: Double) -> CGFloat {
        let height = bounds.size.height
        return height/2 - CGFloat(y*scaleY)
    }
}
