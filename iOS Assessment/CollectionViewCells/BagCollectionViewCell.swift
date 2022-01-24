//
//  BagCollectionViewCell.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 24/01/22.
//

import UIKit

class BagCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lTitle: UILabel!
    @IBOutlet weak var lSize: UILabel!
    @IBOutlet weak var vColor: UIView!
    @IBOutlet weak var lPrice: UILabel!
    @IBOutlet weak var total: UILabel!
    var index: Int = 0
    
    var pan: UIPanGestureRecognizer!
    var deleteLabel2: UIButton!
    
    var delCallback: ((ProductStore)->())?
    
    var dat: ProductStore? {
        didSet{
            ivImage.image = ImagesDatas(index: index)
            lTitle.text = dat?.name
            lSize.text = "Size : \(dat?.sizes ?? "0")"
            vColor.backgroundColor = UIColor(hex: dat?.colors ?? "#000000")
            lPrice.text = "$\(dat?.price?.string() ?? "0")"
            total.text = "\((dat?.total ?? 0) - 1)"
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.contentView.backgroundColor = UIColor.gray
        self.backgroundColor = UIColor.red

        deleteLabel2 = UIButton()
        deleteLabel2.setTitle("DELETE", for: .normal)
        deleteLabel2.setTitleColor(.white, for: .normal)
        self.insertSubview(deleteLabel2, belowSubview: self.contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.deleteTap(_:)))
        self.deleteLabel2.addGestureRecognizer(tap)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }

    override func prepareForReuse() {
        self.contentView.frame = self.bounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if (pan.state == UIGestureRecognizer.State.changed) {
            print("\(pan.translation(in: self).x)")
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            if (pan.translation(in: self).x) > (self.contentView.frame.width - 280) * -1 {
                self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height)
                self.deleteLabel2.frame = CGRect(x: p.x + width, y: 0, width: 100, height: height)
            } else {
                self.contentView.frame = CGRect(x: (self.contentView.frame.width - 280) * -1,y: 0, width: width, height: height)
                self.deleteLabel2.frame = CGRect(x: ((self.contentView.frame.width - 280) * -1) + width, y: 0, width: 100, height: height)
            }
            
        }

    }

    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {

        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if (pan.translation(in: self).x) > (self.contentView.frame.width - 280) * -1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func deleteTap(_ sender: UITapGestureRecognizer? = nil) {
        delCallback!(dat!)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return ((pan.velocity(in: pan.view)).x) < ((pan.velocity(in: pan.view)).y)
    }
    
    @IBAction func actionReduce(_ sender: Any) {
    }
    
    @IBAction func actionAdd(_ sender: Any) {
    }
}
