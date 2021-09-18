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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
