//
//  StackOverflowResponse.swift
//  SearchSO
//
//  Created by utkarsh on 13/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct StackOverflowQuestionResponse: Decodable {
    let items: [Question]
}

struct StackOverflowAnswerResponse: Decodable {
    let items: [Answer]
}
