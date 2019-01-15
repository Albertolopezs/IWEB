//
//  Type.swift
//  Pokedex
//
//  Created by Santiago Pavón on 26/11/14.
//  Copyright (c) 2014 UPM. All rights reserved.
//

import Foundation

/// Estructura para representar un tipo de pokemon.
struct Type {
    
    // Nombre del tipo (agua, fuego, electrico, ...)
    var name: String
    
    // Nombre del icono (sin la extension .png)
    var icon: String
    
    // Todas las razas de este tipo.
    var races: [Race]
}
