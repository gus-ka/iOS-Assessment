//
//  YourBag.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 21/01/22.
//

import UIKit

class YourBag: UIViewController {
    
    @IBOutlet weak var cvBag: UICollectionView!
    @IBOutlet weak var lCheckout: UILabel!
    
    private var productViewModel : ProductViewModel!
    
    let session = Sesion()
    var dat:[ProductStore] = []
    
    var shoe: [Shoe] = []
    
    var total: Double? = 0
    
    var delCallback: ((ProductStore)->())?
    
    var update: ((Bool)->())?
    
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
        
        self.delCallback = {(val) in
            self.session.remBag(val)
            self.dat = self.session.loadBag()
            self.updateDataSource()
        }
        
        self.update = { val in
            if val {
                self.dat = self.session.loadBag()
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
        
        total = 0
        for item in dat {
            total! += ((Double("\(item.total ?? 0)") ?? 0) * (item.price ?? 0))
        }
        
        lCheckout.text = "CHECKOUT - $\(total?.string() ?? "0")"
        
        self.psDataSource = CollectionViewModel(cellIdentifier: "BagCollectionViewCell", items: dat, configureCell: { (cell, evm, idx) in
            cell.index = idx
            cell.dat = evm
            cell.delCallback = self.delCallback
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
            self.cvBag.dataSource = self.psDataSource
            self.cvBag.delegate = self.psDelegate
            self.cvBag.reloadData()
        }
    }
    
    @IBAction func actionCheckout(_ sender: Any) {
    }
    
}
