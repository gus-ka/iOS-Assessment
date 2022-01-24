//
//  StoreCollectionViewDataSource.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 23/01/22.
//

import Foundation
import UIKit

class CollectionViewModel<CELL : UICollectionViewCell,T> : NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var cellIdentifier : String!
    private var items : [T]!
    private var index : Int!
    var configureCell : (CELL, T, Int) -> () = {_,_,_ in }
    var configureDidSellect: ( T, Int) -> () = {_,_ in }
    
    
    init(cellIdentifier : String, items : [T], configureCell : @escaping (CELL, T, Int) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    init(items : [T],didSelectItemAt: @escaping (T, Int) -> ()) {
        self.items = items
        self.configureDidSellect = didSelectItemAt
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        let item = self.items[indexPath.row]
        self.configureCell(cell, item, indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.configureDidSellect(item, indexPath.row)
    }
}
