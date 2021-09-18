//
//  HomePageViewController.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 18/09/21.
//

import UIKit

class HomePageViewController: UITableViewController {
    let domainURL =  "https://my-json-server.typicode.com/nancymadan/assignment/db"
    var gadgetDataModel: GadgetDetails?
    var gadgetsArray: [GadgetDetails]?
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gadgets Store"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cartImage"), style: .plain, target: self, action: #selector(navigateToCheckout))
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.startAnimating()
        
        let url = URL(string: domainURL)
        guard let gadgetsUrl = url  else {
            NSLog("no url found")
            return
        }
        let task = URLSession.shared.dataTask(with: gadgetsUrl) { (data, response, error) in
            if let err = error {
                print("Error with fetching gadgets: \(err)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
              return
            }
            if let data = data {
                let productsList:[String:[GadgetDetails]] = try! JSONDecoder().decode([String: [GadgetDetails]].self, from: data)
                self.gadgetsArray = productsList["products"]
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

extension HomePageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let totalGadgets = self.gadgetsArray?.count else {
            return 0
        }
        return totalGadgets
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gadgetCell", for: indexPath) as? GadgetsTableViewCell
        cell?.gadgetNameLabel.text = gadgetsArray?[indexPath.row].name
        if let price = gadgetsArray?[indexPath.row].price {
            cell?.gadgetPriceLabel.text = "Price: \(String(describing: price))"
        }
        if let rating = gadgetsArray?[indexPath.row].rating {
        cell?.ratingLabel.text = "Rating: \(String(describing: rating))"
        }
        cell?.gadgetImageView.image = getIamgeFromURl(with:gadgetsArray?[indexPath.row].image_url)
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomePageViewController {
    private func getIamgeFromURl(with urlString: String?) -> UIImage? {
        var image = UIImage()
        guard let url = URL(string: urlString ?? "") else {
            return nil
        }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print("Error with fetching images: \(err)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                  return
                }
                if let data = data {
                        image = UIImage(data: data) ?? UIImage()
                }
            }
            task.resume()
        return image
    }
    
    @objc func navigateToCheckout() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let checkoutVC = storyBoard.instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
        self.navigationController?.pushViewController(checkoutVC, animated: true)
    }
}
