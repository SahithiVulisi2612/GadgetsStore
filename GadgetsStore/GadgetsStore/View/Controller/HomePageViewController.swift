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
    var gadgetslistWithHighPrice = [GadgetDetails]()
    var gadgetslistWithLowPrice = [GadgetDetails]()
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
                guard let list = productsList["products"] else {
                    return
                }
                for ele in list {
                    if (Int(ele.price) ?? 0) > 1000 {
                        self.gadgetslistWithHighPrice.append(ele)
                    } else {
                        self.gadgetslistWithLowPrice.append(ele)
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
        view.backgroundColor = .lightGray
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gadgetCell", for: indexPath) as? GadgetsTableViewCell
        if indexPath.section == 0 {
            cell?.configureCell(name: gadgetslistWithLowPrice[indexPath.row].name, price: gadgetslistWithLowPrice[indexPath.row].price, rating: gadgetslistWithLowPrice[indexPath.row].rating, image: getIamgeFromURl(with:gadgetslistWithLowPrice[indexPath.row].image_url))
        } else {
            cell?.configureCell(name: gadgetslistWithHighPrice[indexPath.row].name, price: gadgetslistWithHighPrice[indexPath.row].price, rating: gadgetslistWithHighPrice[indexPath.row].rating, image: getIamgeFromURl(with:gadgetslistWithHighPrice[indexPath.row].image_url))
        }
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
