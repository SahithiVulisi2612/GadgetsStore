//
//  GadgetsTableViewCell.swift
//  GadgetsStore
//
//  Created by Vulisi Sahithi on 18/09/21.
//

import UIKit

protocol SelectedItemsDelegate {
    func itemsSelected(cartData: GadgetsInfo, index: IndexPath?)
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
    var gadgetInfoDataModel: GadgetsInfo?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingStarsArray = [firstRatingStar,secondRatingStar, thirdRatingStar,forthRatingStar,fifthRatingStar]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        delegate?.itemsSelected(cartData: (gadgetInfoDataModel)!, index: index)
    }
    
    func configureCell(data: GadgetsInfo, indexpath: IndexPath) {
        for range in 0 ..< 5 {
            ratingStarsArray[range].isHidden = true
        }
        self.gadgetNameLabel.text = data.gadget.name
        self.gadgetPriceLabel.text = "Price: \(String(describing: data.gadget.price)) INR"
        self.addToCartButton.setTitle(data.itemStatus, for: .normal)
        setUpRatingStars(rating: data.gadget.rating)
        gadgetInfoDataModel = data
        self.index = indexpath
    }
    
    func setUpRatingStars(rating:Int) {
        for range in 0 ..< rating {
            ratingStarsArray[range].isHidden = false
        }
    }
}
