//
//  APIService.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 22/01/22.
//

import Foundation

class APIService :  NSObject {
    
    private let sourcesURL = URL(string: "https://my-json-server.typicode.com/megasuartika/fe-assignment/db")!
    
    func apiToGetProductData(completion : @escaping (ProductItemModel) -> ()){
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                let empData = try! jsonDecoder.decode(ProductItemModel.self, from: data)
                    completion(empData)
            }
        }.resume()
    }
}
