//
//  YourBag.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 21/01/22.
//

import UIKit

class YourBag: UIViewController {
    
    @IBOutlet weak var cvBag: UICollectionView!
    
    private var productViewModel : ProductViewModel!
    
    let session = Sesion()
    var dat:[ProductStore] = []
    
    var shoe: [Shoe] = []
    
    private var psDataSource : CollectionViewModel<BagCollectionViewCell, ProductStore>!
    private var psDelegate : CollectionViewModel<BagCollectionViewCell, ProductStore>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dat = session.loadBag()
        let width  = (view.frame.width)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.cvBag.collectionViewLayout = layout
        self.cvBag!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if let layout = self.cvBag.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: width, height: 230)
            layout.invalidateLayout()
        }
        callToViewModelForUIUpdate()
        updateDataSource()
    }
    
    func callToViewModelForUIUpdate(){
        self.productViewModel =  ProductViewModel()
        self.productViewModel.bindProductViewModelToController = {
            self.shoe = self.productViewModel.productData.shoes ?? []
        }
    }
    
    func updateDataSource(){
        self.psDataSource = CollectionViewModel(cellIdentifier: "BagCollectionViewCell", items: dat, configureCell: { (cell, evm, idx) in
            cell.index = idx
            cell.dat = evm
        })
        
        self.psDelegate = CollectionViewModel(items: dat, didSelectItemAt: { evm, index in
            let storyboard = UIStoryboard.init(name: "DetailItem", bundle: Bundle.main)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailItemID") as! DetailItemVC
            detailVC.index = index
            detailVC.data = self.shoe.first(where: { element in
                element.name == evm.name
            }) ?? self.shoe.first!
            self.present(detailVC, animated: true)
        })
        
        DispatchQueue.main.async {
            self.cvBag.dataSource = self.psDataSource
            self.cvBag.delegate = self.psDelegate
            self.cvBag.reloadData()
        }
    }
}
