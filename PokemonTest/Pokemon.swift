//
//  Pokemon.swift
//  PokemonTest
//
//  Created by Thai Duong on 2/8/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import Foundation

class Pokemon {
    var id = ""
    var name = ""
    var tag = ""
    var gen = ""
    var imageName = ""
    var color = ""
    
    init(id: String, name: String, tag: String, gen: String, imageName: String, color: String) {
        self.id = id
        self.name = name
        self.tag = tag
        self.gen = gen
        self.imageName = imageName
        self.color = color
    }
}
