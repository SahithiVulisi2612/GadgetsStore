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
    @IBOutlet weak var cartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.navigationItem.backBarButtonItem?.tintColor = .black
        self.navigationItem.title = "Cart"
    }
    
    func loadData() {
        fetchResultController = service?.getSelectedGadgets()
        fetchResultController?.delegate = self
    }
    
    @IBAction func checkOutAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cartVC = storyBoard.instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
}
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let sections = fetchResultController?.sections {
            return sections.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController?.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartGadgetCell", for: indexPath) as! GadgetsTableViewCell
        cell.delegate = self
        if let gadget = fetchResultController?.object(at: indexPath) {
            let cartitem = CartItems(gadget: GadgetDetails(name: gadget.name ?? "", price: gadget.price ?? "0", rating: Int(gadget.rating), image_url: gadget.image_url ?? ""), itemStatus: "Remove")
            cell.configureCell(data: cartitem, indexpath: indexPath)
            cell.gadgetImageView?.getImageFromURl(with:gadget.image_url)
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        cartTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let index = indexPath else {return}
        switch type {
        case .delete:
            cartTableView.deleteRows(at: [index], with: .fade)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        cartTableView.endUpdates()
    }

}

extension CartViewController: SelectedItemsDelegate {
    func itemsSelected(cartData: CartItems, index: IndexPath?) {
        guard let indexPath = index else {
            return
        }
        if let gadget = fetchResultController?.object(at: indexPath) {
            self.service?.removeGadget(gadget: gadget)
            cartTableView.reloadData()
        }
    }
}
