//
//  Question.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct Question {
    let questionId: Int
    let owner: Owner
    let title: String
    var score: Int
    var acceptedAnswerId: Int?
}

extension Question: Decodable {
    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case owner
        case title
        case score
        case acceptedAnswerId = "accepted_answer_id"
    }
}
