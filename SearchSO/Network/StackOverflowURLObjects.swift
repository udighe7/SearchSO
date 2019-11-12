//
//  StackOverflowURLObjects.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct StackOverflowQuestionURL {
    var query: String
    var url: URL?
    
    init(searchText: String) {
        self.query = searchText
        let modifiedQuery = self.query.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string:"https://api.stackexchange.com/2.2/search/advanced?order=desc&sort=relevance&q="+modifiedQuery+"%20&site=stackoverflow") else {
            self.url = nil
            return
        }
        self.url = url
    }
}

struct StackOverflowAnswerURL {
    var questionId: String
    var url: URL
    
    init(id: Int) {
        self.questionId = String(id)
        self.url = URL(string: "https://api.stackexchange.com/2.2/questions/"+self.questionId+"/answers?&site=stackoverflow&filter=withbody")!
    }
}

