//
//  CreateStackOverflowObjects.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct WrapperForQuestionAPI: Decodable {
    let items: [Question]
}

struct WrapperForAnswerAPI: Decodable {
    let items: [Answer]
}

struct CreateStackOverflowObjects {
    var jsonData: Data?
    
    func createObjectsForQuestionAPIResponse(query: String) -> (SearchResult?, [Question]?) {
        guard let data = self.jsonData else {
            return (nil,nil)
        }
        let wrapper = try? JSONDecoder().decode(WrapperForQuestionAPI.self, from: data)
        
        if let items = wrapper?.items {
            
            var listOfQuestionIds: [Int] = []
            var listOfQuestions: [Question] = []
            
            for item in items {
                listOfQuestionIds.append(item.questionId)
                listOfQuestions.append(item)
            }
            
            let questionResult = SearchResult(questionIds: listOfQuestionIds, query: query)
            
            return (questionResult, listOfQuestions)
            
        }
        else {
            return (nil,nil)
        }
    }
    
    func createObjectForAnswerAPIResponse() -> Answer? {
        guard let data = self.jsonData else {
            return nil
        }
        
        let wrapper = try? JSONDecoder().decode(WrapperForAnswerAPI.self, from: data)
        var answer: Answer? = nil
        
        if let items = wrapper?.items {
            
            for item in items{
                if item.isAccepted {
                    answer = item
                }
            }
            
            if answer == nil {
                answer = items[0]
            }
            
            return answer
        }
        else {
            return nil
        }
    }

}
