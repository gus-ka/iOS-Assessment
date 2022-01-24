//
//  BagCollectionViewCell.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 24/01/22.
//

import UIKit

class BagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lTitle: UILabel!
    @IBOutlet weak var lSize: UILabel!
    @IBOutlet weak var vColor: UIView!
    @IBOutlet weak var lPrice: UILabel!
    @IBOutlet weak var total: UILabel!
    var index: Int = 0
    
    var dat: ProductStore? {
        didSet{
            ivImage.image = ImagesDatas(index: index)
            lTitle.text = dat?.name
            lSize.text = "Size : \(dat?.sizes ?? "0")"
            vColor.backgroundColor = UIColor(hex: dat?.colors ?? "#000000")
            lPrice.text = "$\(dat?.price?.string() ?? "0")"
            total.text = "\(dat?.total ?? 0)"
        }
    }
}
