//
//  StoreCollectionViewCell.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 23/01/22.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageStore: UIImageView!
    @IBOutlet weak var categoryStore: UILabel!
    @IBOutlet weak var nameStore: UILabel!
    @IBOutlet weak var priceStore: UILabel!
    
    var index : Int? {
        didSet {
            imageStore.image = ImagesDatas(index: index ?? 0)
        }
    }
    
    var productItem : Shoe? {
        didSet {
            categoryStore.text = productItem?.category
            priceStore.text = productItem?.name
            nameStore.text = "$\(productItem?.price!.string() ?? "0")"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
