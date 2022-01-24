//
//  PickerViewModel.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 23/01/22.
//

import Foundation
import UIKit

class PickerViewDataSource<T> : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var items : [T]!
    var configureCell : (T, Int) -> () = {_,_ in }
    
    
    init(items : [T], configureCell : @escaping (T, Int) -> ()) {
        self.items = items
        self.configureCell = configureCell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return (items[row] as! String)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.configureCell(items[row], row)
    }
}
