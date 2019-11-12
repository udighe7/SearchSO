//
//  StackOverflowResource.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

enum StackOverflowObject{
    case questions(String)
    case answer(Int)
}

struct StackOverflowResource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension StackOverflowResource where A: Decodable {
    init?(getObject: StackOverflowObject, parseJSON: @escaping (Data) -> A?) {
        
        switch getObject {
        case .questions(let searchText):
            guard let url = URL(string:"https://api.stackexchange.com/2.2/search/advanced?order=desc&sort=relevance&q="+searchText.replacingOccurrences(of: " ", with: "+")+"%20&site=stackoverflow") else {
                return nil
            }
            self.url = url
        case .answer(let questionId):
            guard let url = URL(string: "https://api.stackexchange.com/2.2/questions/"+String(questionId)+"/answers?&site=stackoverflow&filter=withbody") else {
                return nil
            }
            self.url = url
        }
        
        self.parse = parseJSON
    }
}
