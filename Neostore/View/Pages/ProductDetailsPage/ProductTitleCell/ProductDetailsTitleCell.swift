//
//  ProductDetailsTitleCell.swift
//  Neostore
//
//  Created by Neosoft on 22/08/23.
//

import UIKit

class ProductDetailsTitleCell: UITableViewCell {

    
    @IBOutlet var productratingimages: [UIImageView]!
    @IBOutlet weak var ProductProducer: UILabel!
    @IBOutlet weak var ProductCategory: UILabel!
    @IBOutlet weak var ProductTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setRating(_ rating: Int) {
        var count = 1
        for i in productratingimages {
            if rating >= count {
                i.image = UIImage(systemName: "star.fill")
                count += 1
            }else{
                i.image = UIImage(systemName: "star")
            }
        }
    }
}
