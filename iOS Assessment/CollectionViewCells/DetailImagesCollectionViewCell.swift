//
//  DetailImagesCollectionViewCell.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 23/01/22.
//

import UIKit

class DetailImagesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageSub: UIImageView!
    
    var image : UIImage? {
        didSet {
            imageSub.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
