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
    var url = ""
    var adresses = [String]()
    
    init(name: String, image: String, logo: String, url: String, adresses:[String]) {
        self.name = name
        self.image = image
        self.logo = logo
        self.url = url
        self.adresses = adresses
    }
}
