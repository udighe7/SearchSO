//
//  SearchResult.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

class SearchResult {
    let questionIds: [Int]
    let query: String
    
    init(questionIds: [Int], query: String) {
        self.questionIds = questionIds
        self.query = query
    }
}
