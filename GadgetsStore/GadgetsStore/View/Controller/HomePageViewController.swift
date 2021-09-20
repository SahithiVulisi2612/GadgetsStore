//
//  HomePageViewController.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 18/09/21.
//

import UIKit
import CoreData

class HomePageViewController: UITableViewController {
    let domainURL =  "https://my-json-server.typicode.com/nancymadan/assignment/db"
    var gadgetDataModel: GadgetDetails?
    var gadgetslistWithHighPrice = [GadgetsInfo]()
    var gadgetslistWithLowPrice = [GadgetsInfo]()
    var spinner = UIActivityIndicatorView(style: .large)
    var gadgetImage = UIImage()
    var gadgetService: GadgetService?
    var isAddedToCart: Bool = false
    
    var moc: NSManagedObjectContext? {
        didSet {
            if let moc = moc {
                gadgetService = GadgetService(moc: moc)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gadgets Store"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(navigateToCheckout))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.startAnimating()
        getDataFromApi()
    }
}

// MARK: tableview delegate data source methods
extension HomePageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.gadgetslistWithLowPrice.count
        }else {
            return self.gadgetslistWithHighPrice.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: self.view.frame.width, height: 50))
        if section == 0 {
            label.text = "Gadgets priced below 1000"
        } else {
            label.text = "Gadgets priced above 1000"
        }
        label.textColor = .black
        view.backgroundColor = .white
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gadgetCell", for: indexPath) as? GadgetsTableViewCell
        cell?.delegate = self
        if indexPath.section == 0 {
            cell?.configureCell(data: gadgetslistWithLowPrice[indexPath.row],indexpath: indexPath)
            cell?.gadgetImageView?.getImageFromURl(with:gadgetslistWithLowPrice[indexPath.row].gadget.image_url)
        } else {
            cell?.configureCell(data: gadgetslistWithHighPrice[indexPath.row],indexpath: indexPath)
            cell?.gadgetImageView?.getImageFromURl(with:gadgetslistWithHighPrice[indexPath.row].gadget.image_url)
        }
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension HomePageViewController: SelectedItemsDelegate {
    func itemsSelected(cartData: GadgetsInfo, index: IndexPath?) {
        guard let indexPath = index else {
            return
        }
        if indexPath.section == 0 {
            if !gadgetslistWithLowPrice[indexPath.row].isAddedToCart  {
                gadgetslistWithLowPrice[indexPath.row].isAddedToCart = true
                gadgetslistWithLowPrice[indexPath.row].itemStatus = "Added"
                gadgetService?.addGadget(dataModel: cartData.gadget)
            }
        } else {
            if !gadgetslistWithHighPrice[indexPath.row].isAddedToCart  {
                gadgetslistWithHighPrice[indexPath.row].isAddedToCart = true
                gadgetslistWithHighPrice[indexPath.row].itemStatus = "Added"
                gadgetService?.addGadget(dataModel: cartData.gadget)
            }
        }
        tableView.reloadData()
    }
}

extension HomePageViewController {
    @objc func navigateToCheckout() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cartVC = storyBoard.instantiateViewController(withIdentifier: "cartVC") as! CartViewController
        cartVC.service = gadgetService
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    func errorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDataFromApi() {
        let url = URL(string: domainURL)
        guard let gadgetsUrl = url  else {
            NSLog("no url found")
            return
        }
        let task = URLSession.shared.dataTask(with: gadgetsUrl) { (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {
                    self.errorAlert(message: "Error with fetching gadgets: \(err)")
                    self.spinner.stopAnimating()
                    self.spinner.removeFromSuperview()
                    
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorAlert(message: "Error with the response, unexpected status code: \(String(describing: response))")
                    self.spinner.stopAnimating()
                    self.spinner.removeFromSuperview()
                    
                }
                return
                
            }
            if let data = data {
                let productsList:[String:[GadgetDetails]] = try! JSONDecoder().decode([String: [GadgetDetails]].self, from: data)
                guard let list = productsList["products"] else {
                    return
                }
                for ele in list {
                    if (Int(ele.price) ?? 0) > 1000 {
                        self.gadgetslistWithHighPrice.append(GadgetsInfo(gadget: ele))
                    } else {
                        self.gadgetslistWithLowPrice.append(GadgetsInfo(gadget: ele))
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    self.spinner.removeFromSuperview()
                }
            }
        }
        task.resume()
    }
    
}
