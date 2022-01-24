//
//  ProductViewModel.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 22/01/22.
//

import Foundation
import SQLite3

class ProductViewModel : NSObject {
    
    private var apiService : APIService!
    private(set) var productData : ProductItemModel! {
        didSet {
            self.bindProductViewModelToController()
        }
    }
    
    var bindProductViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
        callFuncToGetProductData()
    }
    
    func callFuncToGetProductData() {
        self.apiService.apiToGetProductData { (productData) in
            self.productData = productData
        }
    }
}
