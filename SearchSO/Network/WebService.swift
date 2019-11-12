//
//  WebService.swift
//  SearchSO
//
//  Created by utkarsh on 13/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

extension URLSession {
    func load<A>(_ resource: StackOverflowResource<A>, completion: @escaping (A?) -> ()) {
        dataTask(with: resource.url) { (data, _, _) -> Void in
            let result = data.flatMap(resource.parse)
            completion(result)
            }.resume()
    }
}
