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
    }

    func callToViewModelForUIUpdate(){
        self.productViewModel =  ProductViewModel()
        self.productViewModel.bindProductViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        self.dataSource = CollectionViewModel(cellIdentifier: "StoreCollectionViewCell", items: self.productViewModel.productData.shoes ?? [], configureCell: { (cell, evm, idx) in
            cell.index = idx
            cell.productItem = evm
        })
        
        self.delegate = CollectionViewModel(items: self.productViewModel.productData.shoes ?? [],didSelectItemAt: { evm, index in
            let storyboard = UIStoryboard.init(name: "DetailItem", bundle: Bundle.main)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailItemID") as! DetailItemVC
            detailVC.index = index
            detailVC.data = evm
            self.present(detailVC, animated: true)
        })
        
        DispatchQueue.main.async {
            self.productCollectionView.dataSource = self.dataSource
            self.productCollectionView.delegate = self.delegate
            self.productCollectionView.reloadData()
        }
    }
}

