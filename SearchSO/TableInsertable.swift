//
//  TableInsertable.swift
//  SearchSO
//
//  Created by utkarsh on 27/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

protocol TableInsertable {
    func getValues() -> [Any]
    init?(values: [Any])
}
