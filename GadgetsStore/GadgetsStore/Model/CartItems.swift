//
//  CartItems.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 19/09/21.
//

import Foundation

struct  CartItems: Codable {
    let gadget: GadgetDetails
    var isAddedToCart: Bool = false
    var itemStatus: String = "Add To Cart"
}
