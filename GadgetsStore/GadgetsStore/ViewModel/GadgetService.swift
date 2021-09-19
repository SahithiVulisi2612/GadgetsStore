//
//  GadgetService.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 19/09/21.
//

import Foundation
import CoreData

class GadgetService {
    
    var moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func addGadget(dataModel: GadgetDetails) {
        let gadgetEntity = Gadgets(context: moc)
        gadgetEntity.name = dataModel.name
        gadgetEntity.image_url = dataModel.image_url
        gadgetEntity.price = dataModel.price
        gadgetEntity.rating = Int16(dataModel.rating)
        save()
        
    }
    
    func getSelectedGadgets() -> NSFetchedResultsController<Gadgets> {
        let fetchResultController: NSFetchedResultsController<Gadgets>
        let req: NSFetchRequest<Gadgets> = Gadgets.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        req.sortDescriptors =  [nameSort]
        fetchResultController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "GadgetsLibrary")
        do {
            try fetchResultController.performFetch()
        }
        catch let error as NSError {
            print("fetching error \(error)")
        }
        return fetchResultController
    }
    
    func removeGadget(gadget: Gadgets) {
        moc.delete(gadget)
        save()
    }
    
    func save() {
        do {
            try moc.save()
        } catch let error as NSError {
            print("could not save\(error)")
        }
    }
}
