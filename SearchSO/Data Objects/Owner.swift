//
//  Owner.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct Owner {
    let ownerId: Int
    let ownerName: String
}

extension Owner: Decodable {
    enum CodingKeys: String, CodingKey {
        case ownerId = "user_id"
        case ownerName = "display_name"
    }
}

extension Owner: Equatable {
    
}
