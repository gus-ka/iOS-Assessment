//
//  StoreVC.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 21/01/22.
//

import UIKit

class StoreVC: UIViewController {
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    private var productViewModel : ProductViewModel!
    
    let session = Sesion()
    
    var update: ((Bool)->())?
    
    private var dataSource : CollectionViewModel<StoreCollectionViewCell, Shoe>!
    private var delegate : CollectionViewModel<StoreCollectionViewCell, Shoe>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width  = (view.frame.width - 20)/2
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.productCollectionView.collectionViewLayout = layout
        self.productCollectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)

        if let layout = self.productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: width, height: (width * 260) / 150)
            layout.invalidateLayout()
        }
        
        callToViewModelForUIUpdate()
        
        self.update = {val in
            if val {
                self.updateBadge()
            }
        }
    }

    func callToViewModelForUIUpdate(){
        self.productViewModel =  ProductViewModel()
        self.productViewModel.bindProductViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateBadge() {
        if let tabItems = self.tabBarController?.tabBar.items {
            let totl = self.session.loadBag().count
            let tabItem = tabItems[2]
            tabItem.badgeValue = totl > 0 ? "\(totl)" : nil
        }
    }
    
    func updateDataSource(){
        self.updateBadge()
        
        self.dataSource = CollectionViewModel(cellIdentifier: "StoreCollectionViewCell", items: self.productViewModel.productData.shoes ?? [], configureCell: { (cell, evm, idx) in
            cell.index = idx
            cell.productItem = evm
        })
        
        self.delegate = CollectionViewModel(items: self.productViewModel.productData.shoes ?? [],didSelectItemAt: { evm, index in
            let storyboard = UIStoryboard.init(name: "DetailItem", bundle: Bundle.main)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailItemID") as! DetailItemVC
            detailVC.index = index
            detailVC.data = evm
            detailVC.update = self.update
            self.present(detailVC, animated: true)
        })
        
        DispatchQueue.main.async {
            self.productCollectionView.dataSource = self.dataSource
            self.productCollectionView.delegate = self.delegate
            self.productCollectionView.reloadData()
        }
    }
    
    @IBAction func actionBtnSort(_ sender: Any) {
    }
    
    @IBAction func actionBtnFilter(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Filter", bundle: Bundle.main)
        let filterVC = storyboard.instantiateViewController(withIdentifier: "FIlterVC") as! FIlterVC
        filterVC.modalPresentationStyle = .overCurrentContext
        self.present(filterVC, animated: true)
    }
}
