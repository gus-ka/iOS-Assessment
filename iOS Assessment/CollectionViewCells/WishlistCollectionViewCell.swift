//
//  WishlistCollectionViewCell.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 24/01/22.
//

import UIKit

class WishlistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lTitle: UILabel!
    @IBOutlet weak var lSize: UILabel!
    @IBOutlet weak var vColor: UIView!
    @IBOutlet weak var lPrice: UILabel!
    var index: Int = 0
    
    var reqUpdate:((Bool)->())?
    
    let session = Sesion()
    
    var dat: ProductStore? {
        didSet{
            ivImage.image = ImagesDatas(index: index)
            lTitle.text = dat?.name
            lSize.text = "Size : \(dat?.sizes ?? "0")"
            vColor.backgroundColor = UIColor(hex: dat?.colors ?? "#000000")
            lPrice.text = "$\(dat?.price?.string() ?? "0")"
        }
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        let allDat = session.load()
        if let row = allDat.firstIndex(where: {$0.name == lTitle.text}) {
            session.setFav(allDat[row])
            reqUpdate!(true)
        }
    }
    
    @IBAction func actionAddToBag(_ sender: Any) {
        let allDat = session.load()
        if let row = allDat.firstIndex(where: {$0.name == lTitle.text}) {
            session.setBag(allDat[row])
            reqUpdate!(false)
        }
    }
}
