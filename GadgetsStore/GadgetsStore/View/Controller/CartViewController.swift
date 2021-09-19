//
//  CartViewController.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 19/09/21.
//

import CoreData
import UIKit

class CartViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var service: GadgetService?
    private var fetchResultController: NSFetchedResultsController<Gadgets>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        fetchResultController = service?.getSelectedGadgets()
        fetchResultController?.delegate = self
    }

}
