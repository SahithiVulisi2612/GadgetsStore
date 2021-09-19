//
//  CheckoutViewController.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 18/09/21.
//

import UIKit

class CheckoutViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var orderInfoLabel: UILabel!
    @IBOutlet weak var congratsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = .black
        self.navigationItem.title = "Check Out"
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.view.alpha = 0.4
        spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            self?.spinner.stopAnimating()
            self?.view.backgroundColor = .white
            self?.view.alpha = 1
            self?.congratsImageView.isHidden = false
            self?.orderInfoLabel.isHidden = false
        }
    }
}
