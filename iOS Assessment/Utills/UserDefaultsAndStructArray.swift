//
//  UserDefaultsAndStructArray.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 24/01/22.
//

import Foundation

let KeyForUserDefaults = "myProductsKey"

class Sesion {
    func save(_ product: [ProductStore]) {
        let data = product.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
    }
    
    func setFav(_ product: ProductStore) {
        var allDat = load()
        let checkFav = allDat.contains(where: { $0.name == product.name })
        if checkFav {
            if let row = allDat.firstIndex(where: {$0.name == product.name}) {
                let dat = ProductStore(name: product.name, category: product.category, shoeDescription: product.shoeDescription, price: product.price, sizes: product.sizes, colors: product.colors, video: product.video, isFav: !(allDat[row].isFav ?? false), isInTheBag: (allDat[row].isInTheBag ?? false), total: (allDat[row].total ?? 0))
                   allDat[row] = dat
                save(allDat)
            }
        } else {
            allDat.append(product)
            save(allDat)
        }
    }
    
    func setBag(_ product: ProductStore) {
        var allDat = load()
        if let row = allDat.firstIndex(where: {$0.name == product.name}) {
            let dat = ProductStore(name: product.name, category: product.category, shoeDescription: product.shoeDescription, price: product.price, sizes: product.sizes, colors: product.colors, video: product.video, isFav: (allDat[row].isFav ?? false), isInTheBag: true, total: (allDat[row].total ?? 0) + 1)
            allDat[row] = dat
            save(allDat)
        }
    }
    
    func remBag(_ product: ProductStore) {
        var allDat = load()
        if let row = allDat.firstIndex(where: {$0.name == product.name}) {
            let dat = ProductStore(name: product.name, category: product.category, shoeDescription: product.shoeDescription, price: product.price, sizes: product.sizes, colors: product.colors, video: product.video, isFav: (allDat[row].isFav ?? false), isInTheBag: false, total: 1)
            allDat[row] = dat
            print(allDat)
            save(allDat)
        }
    }

    func load() -> [ProductStore] {
        guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
            return []
        }

        return encodedData.map { try! JSONDecoder().decode(ProductStore.self, from: $0) }
    }
    
    func loadFav() -> [ProductStore] {
        return load().filter { element in
            return element.isFav == true
        }
    }
    
    func loadBag() -> [ProductStore] {
        return load().filter { element in
            return element.isInTheBag == true
        }
    }
}

