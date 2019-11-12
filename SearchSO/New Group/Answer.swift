//
//  Answer.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct Answer {
    let answerId: Int
    let owner: Owner
    var score: Int
    var body: String
    var isAccepted: Bool
}

extension Answer: Decodable {
    enum CodingKeys: String, CodingKey {
        case answerId = "answer_id"
        case owner
        case score
        case body
        case isAccepted = "is_accepted"
    }
}

extension Answer: Equatable {
    
}
