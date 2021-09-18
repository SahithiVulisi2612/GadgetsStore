//
//  GadgetDetails.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 18/09/21.
//

import UIKit

struct  GadgetDetails: Codable {
    let name: String
    let price: String
    let rating: Int
    let image_url: String
    
    init(name: String, price: String, rating: Int, image_url: String) {
        self.name = name
        self.price = price
        self.rating = rating
        self.image_url = image_url
    }
}
