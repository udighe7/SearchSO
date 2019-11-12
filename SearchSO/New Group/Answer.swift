//
//  Answer.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

class Answer {
    let answerId: Int
    let owner: Owner
    var score: Int
    var body: String
    var isAccepted: Bool
    
    init(id: Int, owner: Owner, score: Int, body: String, isAccepted: Bool) {
        self.answerId = id
        self.owner = owner
        self.score = score
        self.body = body
        self.isAccepted = isAccepted
    }

}
