//
//  Network.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct Network {
    var url: URL
    
    func getJsonData(completionHandler: @escaping (Data?) -> Void) {
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task = session.dataTask(with: self.url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let jsonData = data {
                completionHandler(jsonData)
            } else {
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
}
