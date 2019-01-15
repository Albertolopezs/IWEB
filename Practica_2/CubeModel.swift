//
//  CubeModel.swift
//  Practica 2
//
//  Created by g820 DIT UPM on 21/9/18.
//  Copyright © 2018 g820 DIT UPM. All rights reserved.
//

import Foundation

class CubeModel {
    
    //Valor de la gravedad en la tierra
    let g = 9.8
    // Numero de puntos en el eje X por unidad representada

    var angSpeed: Double = sqrt(4.9)
    var aristSize: Double = 4.0 {
        didSet{
            angSpeedCalc()
        }
    }
    
    private func angSpeedCalc(){
        
        angSpeed = sqrt(2*g/aristSize)
        
    }
    
    func posAtTime(_ time: Double) -> Double {
        
        let pos = 1/2 * aristSize * cos(angSpeed * time)
        return pos
        
    }
    
    func speedAtTime(_ time: Double) -> Double {
        
        let pos = -1/2  * aristSize * (angSpeed * sin(angSpeed * time))
        return pos
        
    }
    
    func acelAtTime(_ time: Double) -> Double {
        
        let pos = -g * cos(angSpeed * time)
        return pos
        
    }
    

}
