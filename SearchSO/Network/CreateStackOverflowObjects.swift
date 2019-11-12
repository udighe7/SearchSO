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

}
