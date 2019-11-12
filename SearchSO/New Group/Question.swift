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
