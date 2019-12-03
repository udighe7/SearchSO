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

extension Question: Equatable {
    
}

extension Question: TableInsertable {
    
    func getValues() -> [Any] {
        var values:[Any] = []
        values.append(Int32(self.questionId))
        let owner = String(self.owner.ownerId) + " " + self.owner.ownerName
        values.append(owner)
        values.append(Int32(self.score))
        values.append(self.title)
        if let answerId = self.acceptedAnswerId {
            values.append(Int32(answerId))
        }
        else {
            values.append(Int32(0))
        }
        return values
    }
    
    init?(values: [Any]) {
        if let questionId = values[0] as? Int32 {
            self.questionId = Int(questionId)
        }
        else {
            return nil
        }
        if let ownerString = values[1] as? String {
            let ownerDetails = ownerString.split(separator: " ")
            let owner = Owner(ownerId: Int(ownerDetails[0])!, ownerName: String(ownerDetails[1]))
            self.owner = owner
        }
        else {
            return nil
        }
        if let score = values[2] as? Int32 {
            self.score = Int(score)
        }
        else {
            return nil
        }
        if let title = values[3] as? String {
            self.title = title
        }
        else {
            return nil
        }
        if let answerId = values[4] as? Int32 {
            if answerId != 0 {
                self.acceptedAnswerId = Int(answerId)
            }
            else {
                self.acceptedAnswerId = nil
            }
        }
        else {
            return nil
        }
    }
}
