//
//  Wishlist.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 21/01/22.
//

import UIKit

class Wishlist: UIViewController {
    
    @IBOutlet weak var cvWishlist: UICollectionView!
    let session = Sesion()
    var dat:[ProductStore] = []
    
    private var productViewModel : ProductViewModel!
    
    var shoe: [Shoe] = []
    
    var reqUpdate:((Bool)->())?
    
    var update: ((Bool)->())?
    
    private var psDataSource : CollectionViewModel<WishlistCollectionViewCell, ProductStore>!
    private var psDelegate : CollectionViewModel<WishlistCollectionViewCell, ProductStore>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dat = session.loadFav()
        let width  = (view.frame.width)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.cvWishlist.collectionViewLayout = layout
        self.cvWishlist!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if let layout = self.cvWishlist.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: width, height: 230)
            layout.invalidateLayout()
        }
        callToViewModelForUIUpdate()
        updateDataSource()
        self.reqUpdate = { (val) -> Void in
            if val {
                self.showToast(message: "Item Removed", font: .systemFont(ofSize: 16.0))
                self.dat = self.session.loadFav()
                self.updateDataSource()
            } else {
                self.showToast(message: "Item added to the bag", font: .systemFont(ofSize: 16.0))
            }
        }
        self.update = { val in
            if val {
                self.dat = self.session.loadFav()
                self.updateDataSource()
            }
        }
    }
    
    func callToViewModelForUIUpdate(){
        self.productViewModel =  ProductViewModel()
        self.productViewModel.bindProductViewModelToController = {
            self.shoe = self.productViewModel.productData.shoes ?? []
        }
    }
    
    func updateDataSource(){
        if let tabItems = tabBarController?.tabBar.items {
            let totl = session.loadBag().count
            let tabItem = tabItems[2]
            tabItem.badgeValue = totl > 0 ? "\(totl)" : nil
        }
        
        self.psDataSource = CollectionViewModel(cellIdentifier: "WishlistCollectionViewCell", items: dat, configureCell: { (cell, evm, idx) in
            cell.index = idx
            cell.dat = evm
            cell.reqUpdate = self.reqUpdate
        })
        
        self.psDelegate = CollectionViewModel(items: dat, didSelectItemAt: { evm, index in
            let storyboard = UIStoryboard.init(name: "DetailItem", bundle: Bundle.main)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailItemID") as! DetailItemVC
            detailVC.index = index
            detailVC.data = self.shoe.first(where: { element in
                element.name == evm.name
            }) ?? self.shoe.first!
            detailVC.update = self.update
            self.present(detailVC, animated: true)
        })
        
        DispatchQueue.main.async {
            self.cvWishlist.dataSource = self.psDataSource
            self.cvWishlist.delegate = self.psDelegate
            self.cvWishlist.reloadData()
        }
    }
}
