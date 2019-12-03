//
//  SearchResult.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct SearchResult {
    let questionId: Int
    let query: String
}

extension SearchResult: Equatable {
    
}

extension SearchResult: TableInsertable {
    
    func getValues() -> [Any] {
        var values: [Any] = []
        values.append(self.query)
        values.append(Int32(self.questionId))
        return values
    }
    
    init?(values: [Any]) {
        if let query = values[1] as? String {
            self.query = query
        }
        else {
            return nil
        }
        if let questionId = values[2] as? Int32 {
            self.questionId = Int(questionId)
        }
        else {
            return nil
        }
    }
}
