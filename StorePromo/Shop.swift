//
//  Shop.swift
//  StorePromo
//
//  Created by Admin on 28.07.16.
//  Copyright © 2016 fahrenheit. All rights reserved.
//

import Foundation

class Shop {
    var name = ""
    var image = ""
    var logo = ""
    var adresses = [String]()
    
    init(name: String, image: String, logo: String, adresses:[String]) {
        self.name = name
        self.image = image
        self.logo = logo
        self.adresses = adresses
    }
}
