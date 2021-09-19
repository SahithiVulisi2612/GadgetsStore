//
//  Gadgets+CoreDataProperties.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 19/09/21.
//
//

import Foundation
import CoreData


extension Gadgets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gadgets> {
        return NSFetchRequest<Gadgets>(entityName: "Gadgets")
    }

    @NSManaged public var name: String?
    @NSManaged public var rating: Int16
    @NSManaged public var price: String?
    @NSManaged public var image_url: String?

}

extension Gadgets : Identifiable {

}
