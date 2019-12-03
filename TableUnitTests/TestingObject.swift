//
//  TestingObject.swift
//  TableUnitTests
//
//  Created by utkarsh on 01/12/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation
@testable import SearchSO


struct TestingObject {
    var integer: Int
    var string: String
    var optionalInt: Int?
    var flag: Bool
    
}

extension TestingObject: Equatable {
    
}

extension TestingObject: TableInsertable {
    
    func getValues() -> [Any]{
        var listOfValues:[Any] = []
        listOfValues.append(Int32(integer))
        listOfValues.append(string)
        if let integer = optionalInt {
            listOfValues.append(Int32(integer))
        }
        else {
            listOfValues.append(Int32(0))
        }
        if flag {
            listOfValues.append(Int32(1))
        }
        else {
            listOfValues.append(Int32(0))
        }
        
        return listOfValues
    }
    
    init?(values: [Any]){
        if let integer = values[0] as? Int32 {
            self.integer = Int(integer)
        }
        else {
            return nil
        }
        if let string = values[1] as? String {
            self.string = string
        }
        else {
            return nil
        }
        if let integer = values[2] as? Int32 {
            if integer != 0 {
                self.optionalInt = Int(integer)
            }
            else {
                self.optionalInt = nil
            }
        }
        else {
            return nil
        }
        if let flag = values[3] as? Int32 {
            if flag == 0 {
                self.flag = false
            }
            else {
                self.flag = true
            }
        }
        else {
            return nil
        }
    }
}
