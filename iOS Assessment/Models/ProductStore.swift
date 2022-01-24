//
//  ProductStoreModel.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 24/01/22.
//

import Foundation

struct ProductStore: Codable {
    let name: String?
    let category: String?
    let shoeDescription: String?
    let price: Double?
    let sizes: String?
    let colors: String?
    let video: String?
    let isFav: Bool?
    let isInTheBag: Bool?
    let total: Int?
}
