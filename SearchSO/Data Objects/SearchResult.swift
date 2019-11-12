//
//  SearchResult.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct SearchResult {
    let questionIds: [Int]
    let query: String
}

extension SearchResult: Equatable {
    
}
