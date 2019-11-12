//
//  Question.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

class Question {
    let questionId: Int
    let owner: Owner
    let title: String
    var score: Int
    var acceptedAnswerId: Int?
    
    init(id: Int, owner: Owner, title: String, score: Int, answerId: Int?) {
        self.questionId = id
        self.owner = owner
        self.title = title
        self.score = score
        self.acceptedAnswerId = answerId
    }
}
