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
    let questionId: Int
    
}

extension Answer: Decodable {
    enum CodingKeys: String, CodingKey {
        case answerId = "answer_id"
        case owner
        case score
        case body
        case isAccepted = "is_accepted"
        case questionId = "question_id"
    }
}

extension Answer: Equatable {
    
}

extension Answer: TableInsertable {
    
    func getValues() -> [Any] {
        var values: [Any] = []
        values.append(Int32(self.answerId))
        let owner = String(self.owner.ownerId) + " " + self.owner.ownerName
        values.append(owner)
        values.append(Int32(self.score))
        values.append(self.body)
        if self.isAccepted {
            values.append(Int32(1))
        }
        else {
            values.append(Int32(0))
        }
        values.append(Int32(self.questionId))
        return values
    }
    
    init?(values: [Any]) {
        if let answerId = values[0] as? Int32 {
            self.answerId = Int(answerId)
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
        if let body = values[3] as? String {
            self.body = body
        }
        else {
            return nil
        }
        if let isAccepted = values[4] as? Int32 {
            if isAccepted != 0 {
                self.isAccepted = true
            }
            else {
                self.isAccepted = false
            }
        }
        else {
            return nil
        }
        if let questionId = values[5] as? Int32 {
            self.questionId = Int(questionId)
        }
        else {
            return nil
        }
    }
}
