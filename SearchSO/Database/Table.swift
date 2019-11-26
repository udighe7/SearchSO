//
//  Table.swift
//  SearchSO
//
//  Created by utkarsh on 20/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct Table {
    var tableName: String
    var columnTypes: [String]
    var createQuery: String
    var insertQuery: String
    var readQuery: String
}
