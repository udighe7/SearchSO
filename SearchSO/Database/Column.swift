//
//  Column.swift
//  SearchSO
//
//  Created by utkarsh on 27/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

enum TableColumnType: String{
    case string = "CHAR"
    case integer = "INT"
}

struct Column {
    let name: String
    let type: TableColumnType
    let constraint: String
}
