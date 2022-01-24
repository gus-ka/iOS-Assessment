//
//  DetailVC.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 23/01/22.
//

import UIKit

class DetailItemVC: UIViewController {
    
    @IBOutlet weak var lTitle: UILabel!
    @IBOutlet weak var lCategory: UILabel!
    @IBOutlet weak var lPrice: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var cvImages: UICollectionView!
    @IBOutlet weak var lSize: UILabel!
    @IBOutlet weak var cvColors: UICollectionView!
    @IBOutlet weak var lDescription: UILabel!
    @IBOutlet weak var lBtnAddToBag: UILabel!
    @IBOutlet weak var btnSize: UIButton!
    @IBOutlet weak var ivFav: UIImageView!
    
    var indexColor: Int? = 0
    var listSize: [String] = []
    var listColor: [String] = []
    
    var update: ((Bool)->())?
    
    var toolBar = UIToolbar()
    var pickerView = UIPickerView()
    private var pvDataSource : PickerViewDataSource<String>!
    
    var index: Int = 0
    var data: Shoe = Shoe(name: "", category: "", shoeDescription: "", price: 0, sizes: [], colors: [], video: "")
    
    private var cvImageDataSource : CollectionViewModel<DetailImagesCollectionViewCell, UIImage?>!
    private var cvImageDelegate : CollectionViewModel<DetailImagesCollectionViewCell, UIImage?>!
    
    private var cvColorDataSource : CollectionViewModel<DetailColorCollectionViewCell, ColorP?>!
    private var cvColorDelegate : CollectionViewModel<DetailColorCollectionViewCell, ColorP?>!
    
    let session = Sesion()
    var dat:[ProductStore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ivImage.image = ImagesDatas(index: index)
        self.lTitle.text = data.name
        self.lCategory.text = data.category
        self.lPrice.text = "$\(data.price?.string() ?? "0")"
        self.lSize.text = data.sizes?.first
        self.lDescription.text = data.shoeDescription
        self.lBtnAddToBag.text = "ADD TO BAG — $\(data.price?.string() ?? "0")"
        dat = session.load()
        if session.load().contains(where: {$0.name == data.name && $0.isFav == true}) {
            ivFav.image = UIImage(named: "icon_favorite_on")
        } else {
            ivFav.image = UIImage(named: "icon_favorite")
        }
        updateCVImageDataSource()
        updateCVColorDataSource()
    }
    
    func updateCVImageDataSource(){
        
        let width  = (view.frame.width - 80)/3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.cvImages.collectionViewLayout = layout
        self.cvImages.isPagingEnabled = true
        self.cvImages.showsVerticalScrollIndicator = false
        self.cvImages.showsHorizontalScrollIndicator = false
        self.cvImages!.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)

        if let layout = self.cvImages.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 20
            layout.itemSize = CGSize(width: width, height: width)
            layout.invalidateLayout()
        }
        
        self.cvImageDataSource = CollectionViewModel(cellIdentifier: "DetailImagesCollectionViewCell", items: imageList, configureCell: { (cell, evm, idx) in
            cell.image = ImagesDatas(index: idx)
        })
        
        self.cvImageDelegate = CollectionViewModel(items: imageList,didSelectItemAt: { evm, index in
        })
        
        DispatchQueue.main.async {
            self.cvImages.dataSource = self.cvImageDataSource
            self.cvImages.delegate = self.cvImageDelegate
            self.cvImages.reloadData()
        }
    }
    
    func updateCVColorDataSource(){
        
        let width  = 42
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.cvColors.collectionViewLayout = layout
        self.cvColors.isPagingEnabled = true
        self.cvColors.showsVerticalScrollIndicator = false
        self.cvColors.showsHorizontalScrollIndicator = false
        self.cvColors!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)

        if let layout = self.cvColors.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.itemSize = CGSize(width: width, height: width)
            layout.invalidateLayout()
        }
        
        self.cvColorDataSource = CollectionViewModel(cellIdentifier: "DetailColorCollectionViewCell", items: data.colors ?? [], configureCell: { (cell, evm, idx) in
            cell.vCircle.backgroundColor = (self.indexColor == idx ?  UIColor(hex:"#000000") : UIColor(hex: evm?.colorHash ?? "#FFFFFF"))
            cell.vSubCircle.backgroundColor = UIColor(hex: evm?.colorHash ?? "#FFFFFF")
        })
        
        self.cvColorDelegate = CollectionViewModel(items: data.colors ?? [],didSelectItemAt: { evm, index in
            self.indexColor = index
            self.cvColors.reloadData()
        })
        
        DispatchQueue.main.async {
            self.cvColors.dataSource = self.cvColorDataSource
            self.cvColors.delegate = self.cvColorDelegate
            self.cvColors.reloadData()
        }
    }
    
    @objc func onDoneButtonTapped() {
        self.toolBar.removeFromSuperview()
        self.pickerView.removeFromSuperview()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionBtnSize(_ sender: Any) {
        self.pvDataSource = PickerViewDataSource(items: (self.data.sizes ?? []) as [String], configureCell: { (evm: String, index) in
            self.lSize.text = evm
            self.toolBar.removeFromSuperview()
            self.pickerView.removeFromSuperview()
        })
        
        self.pickerView.dataSource = self.pvDataSource
        self.pickerView.delegate = self.pvDataSource
        self.pickerView.backgroundColor = UIColor.white
        self.pickerView.setValue(UIColor.black, forKey: "textColor")
        self.pickerView.autoresizingMask = .flexibleWidth
        self.pickerView.contentMode = .center
        self.pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(self.pickerView)
                    
        self.toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        self.toolBar.barStyle = .black
        self.toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            self.view.addSubview(toolBar)
    }
    
    @IBAction func actionFav(_ sender: Any) {
        let product = ProductStore(name: data.name ?? "", category: data.category ?? "", shoeDescription: data.shoeDescription ?? "", price: data.price ?? 0, sizes: "\(lSize.text ?? "0")", colors: "\(data.colors?[indexColor ?? 0].colorHash ?? "#000000")", video:  data.video ?? "", isFav: true, isInTheBag: session.load().contains(where: {$0.name == data.name && $0.isInTheBag == true}), total: 1)
        session.setFav(product)
        update!(true)
        if session.load().contains(where: {$0.name == data.name && $0.isFav == true}) {
            ivFav.image = UIImage(named: "icon_favorite_on")
        } else {
            ivFav.image = UIImage(named: "icon_favorite")
        }
    }
    
    @IBAction func actionAddToBag(_ sender: Any) {
        let product = ProductStore(name: data.name ?? "", category: data.category ?? "", shoeDescription: data.shoeDescription ?? "", price: data.price ?? 0, sizes: "\(lSize.text ?? "0")", colors: "\(data.colors?[indexColor ?? 0].colorHash ?? "#000000")", video: data.video ?? "", isFav: session.load().contains(where: {$0.name == data.name && $0.isFav == true}), isInTheBag: true, total: 0)
        session.setBag(product)
        update!(true)
        self.showToast(message: "\(product.name ?? "") added", font: .systemFont(ofSize: 16.0))
    }
}
