//
//  ProductItemModel.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 22/01/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productItemModel = try? newJSONDecoder().decode(ProductItemModel.self, from: jsonData)

import Foundation

// MARK: - ProductItemModel
struct ProductItemModel: Codable {
    let shoes: [Shoe]?
}

// MARK: - Shoe
struct Shoe: Codable {
    let name, category, shoeDescription: String?
    let price: Double?
    let sizes: [String]?
    let colors: [ColorP]?
    let video: String?

    enum CodingKeys: String, CodingKey {
        case name, category
        case shoeDescription = "description"
        case price, sizes, colors, video
    }
}

// MARK: - Color
struct ColorP: Codable {
    let name: String?
    let colorHash: String?

    enum CodingKeys: String, CodingKey {
        case name
        case colorHash = "color_hash"
    }
}
