//
//  PokedexModel.swift
//  Pokedex
//
//  Created by Santiago Pavón on 30/09/16.
//  Copyright (c) 2016 UPM. All rights reserved.
//

import Foundation

/// Modelo de datos de los pokemons.
/// Tiene información sobre las razas y los tipos de pokemons.
class PokedexModel {
    
    /// Array de objetos Race.
    var races = [Race]()
    
    /// Array de objetos Type.
    var types = [Type]()
    
    /// Carga los datos de pokedex.plist en las propiedades races y types.
    init() {
        guard let url = Bundle.main.url(forResource: "pokedex",
                                        withExtension: "plist"),
            let plist = NSDictionary(contentsOf: url) as? [String:Any],
            let allRaces = plist["races"] as? [[String:Any]],
            let allTypes = plist["types"] as? [[String:Any]] else { return }
        
        races = allRaces.map({ (dic) in
            let raceName = dic["name"] as! String
            let raceIcon = dic["icon"] as! String
            let raceCode = dic["code"] as! Int
            
            return Race(code: raceCode, name: raceName, icon: raceIcon)
        }).sorted(by: { $0.name < $1.name })

        types = allTypes.map({ (dic) in
            let typeName = dic["name"] as! String
            let typeIcon = dic["icon"] as! String
            let typeCodes = dic["codes"] as! [Int]
            let typeRaces = races.filter({ (race) -> Bool in
                typeCodes.contains(where: { $0 == race.code })
            }).sorted(by: { $0.name < $1.name })
            
            return Type(name: typeName, icon: typeIcon, races: typeRaces  )
        }).sorted(by: { $0.name < $1.name })
    }
}




