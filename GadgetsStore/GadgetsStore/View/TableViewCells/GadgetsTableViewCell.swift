//
//  GadgetsTableViewCell.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 18/09/21.
//

import UIKit

class GadgetsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var gadgetImageView: UIImageView!
    @IBOutlet weak var gadgetNameLabel: UILabel!
    @IBOutlet weak var gadgetPriceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addToCartButton.tag = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setTitle("Add To Cart", for: .normal)
            sender.tag = 1
        } else if sender.tag == 1 {
            sender.setTitle("Added", for: .normal)
        }
    }
    
    func configureCell(name: String?, price: String?, rating: Int?, image: UIImage?) {
        self.gadgetNameLabel.text = name
        self.gadgetImageView.image = image
        self.gadgetPriceLabel.text = "Price: \(String(describing: price))"
        self.ratingLabel.text = "Rating: \(String(rating ?? 0))"
    }
    

}
