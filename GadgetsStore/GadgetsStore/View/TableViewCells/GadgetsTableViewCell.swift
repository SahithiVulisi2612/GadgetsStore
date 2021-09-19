//
//  GadgetsTableViewCell.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 18/09/21.
//

import UIKit

protocol SelectedItemsDelegate {
    func itemsSelected()
}

class GadgetsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gadgetImageView: UIImageView!
    @IBOutlet weak var gadgetNameLabel: UILabel!
    @IBOutlet weak var gadgetPriceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var firstRatingStar: UIButton!
    
    @IBOutlet weak var thirdRatingStar: UIButton!
    @IBOutlet weak var secondRatingStar: UIButton!
    @IBOutlet weak var fifthRatingStar: UIButton!
    @IBOutlet weak var forthRatingStar: UIButton!
    var ratingStarsArray = [UIButton]()
    var delegate: SelectedItemsDelegate?
    var count = 0
    var service: GadgetService?
    var gadgetDataModel: GadgetDetails?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingStarsArray = [firstRatingStar,secondRatingStar, thirdRatingStar,forthRatingStar,fifthRatingStar]
        if count == 1 {
            addToCartButton.setTitle("Added", for: .normal)
            count = 0
        }
        else {
            addToCartButton.setTitle("Add To Cart", for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
//        if count == 0 {
//            sender.setTitle("Add To Cart", for: .normal)
            count = 1
//        } else if count == 1 {
            sender.setTitle("Added", for: .normal)
//        }
        service?.addGadget(dataModel: gadgetDataModel ?? GadgetDetails(name: "", price: "", rating: 0, image_url: ""))
        delegate?.itemsSelected()
    }
    
    func configureCell(data: GadgetDetails) {
        for range in 0 ..< 5 {
            ratingStarsArray[range].isHidden = true
        }
        self.gadgetNameLabel.text = data.name
//        if let gadgetPrice = data.price {
            self.gadgetPriceLabel.text = "Price: \(String(describing: data.price)) INR"
//        }
        setUpRatingStars(rating: data.rating)
        gadgetDataModel = data
    }
    
    func setUpRatingStars(rating:Int) {
        for range in 0 ..< rating {
            ratingStarsArray[range].isHidden = false
        }
    }
}
