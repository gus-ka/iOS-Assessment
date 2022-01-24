//
//  ImageList.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 23/01/22.
//

import Foundation
import UIKit

let imageList = [
    UIImage(named: "Image0"),
    UIImage(named: "Image1"),
    UIImage(named: "Image2"),
    UIImage(named: "Image3"),
    UIImage(named: "Image4"),
    UIImage(named: "Image5"),
    UIImage(named: "Image6"),
    UIImage(named: "Image7"),
    UIImage(named: "Image8"),
    UIImage(named: "Image9"),
]

func ImagesDatas(index: Int) -> UIImage {
    var idx: Int = 0
    if index < 10 {
        idx = index
    } else {
        idx = index % 10
    }
    return imageList[idx]!
}
