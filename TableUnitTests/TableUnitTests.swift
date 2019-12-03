//
//  TableUnitTests.swift
//  TableUnitTests
//
//  Created by utkarsh on 01/12/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import XCTest
import SQLite3
@testable import SearchSO

class TableUnitTests: XCTestCase {
    var sut: Table<TestingObject>!
    let sqliteFileName = "Testing"
    let tableName = "Test"
    
    override func setUp() {
        super.setUp()
        var columns: [Column] = []
        let column1 = Column(name: "Id", type : .integer, constraint : "PRIMARY KEY")
        columns.append(column1)
        let column2 = Column(name: "String", type : .string, constraint : "")
        columns.append(column2)
        let column3 = Column(name: "Optional", type : .integer, constraint : "")
        columns.append(column3)
        let column4 = Column(name: "Flag", type : .integer, constraint : "")
        columns.append(column4)
        sut = Table(tableName: tableName, columns: columns, sqlFileName: sqliteFileName)
    }

    override func tearDown() {
        do {
            let dbURL: URL
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = documentDirectory.appendingPathComponent(sqliteFileName).appendingPathExtension("sqlite")
            var db: OpaquePointer? = nil
            if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
                print("Successfully opened connection to database at \(dbURL).")
                let dropTableQuery = """
                DROP TABLE \(tableName);
                """
                var statement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, dropTableQuery, -1, &statement, nil) == SQLITE_OK {
                    if sqlite3_step(statement) != SQLITE_DONE {
                        print("Error occurred while dropping table for teardown.")
                    }
                }
                sqlite3_finalize(statement)
                if sqlite3_close(db) == SQLITE_OK {
                    print("DB closed successfully.")
                }
            }
            else {
                print("Error occured while opening DB.")
            }
        }
        catch {
            print(error)
        }
        sut = nil
        super.tearDown()
    }
    
    func testCreateOperation() {
        do {
            let dbURL: URL
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = documentDirectory.appendingPathComponent(sqliteFileName).appendingPathExtension("sqlite")
            var db: OpaquePointer? = nil
            if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
                defer {
                    if sqlite3_close(db) == SQLITE_OK {
                        print("DB closed successfully.")
                    }
                }
                print("Successfully opened connection to database at \(dbURL).")
                let createTableQuery = """
                CREATE TABLE \(tableName)(
                Id INT PRIMARY KEY,
                String CHAR,
                Optional INT,
                Flag INT);
                """
                var statement: OpaquePointer? = nil
                defer {
                    sqlite3_finalize(statement)
                }
                guard sqlite3_prepare_v2(db, createTableQuery, -1, &statement, nil) == SQLITE_OK
                else {
                    XCTAssert(true)
                    return
                }
                XCTFail("Create operation wasn't successful.")
            }
            else {
                XCTFail("Error occured while opening DB.")
            }
        }
        catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
    
    func testInsertOperation() {
        let object = TestingObject(integer: 123, string: "ABC", optionalInt: 456, flag: true)
        sut.insert(insertObject: object)
        do {
            let dbURL: URL
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = documentDirectory.appendingPathComponent(sqliteFileName).appendingPathExtension("sqlite")
            var db: OpaquePointer? = nil
            if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
                defer {
                    if sqlite3_close(db) == SQLITE_OK {
                        print("DB closed successfully.")
                    }
                }
                print("Successfully opened connection to database at \(dbURL).")
                let readTableQuery = """
                SELECT * FROM \(tableName) WHERE Id=123
                """
                var statement: OpaquePointer? = nil
                defer {
                    sqlite3_finalize(statement)
                }
                if sqlite3_prepare_v2(db, readTableQuery, -1, &statement, nil) == SQLITE_OK {
                    if sqlite3_step(statement) == SQLITE_ROW {
                        var temp: [Any] = []
                        temp.append(sqlite3_column_int(statement, 0))
                        let stringResult = sqlite3_column_text(statement, 1)
                        temp.append(String(cString: stringResult!))
                        temp.append(sqlite3_column_int(statement, 2))
                        temp.append(sqlite3_column_int(statement, 3))
                        let dbObject = TestingObject.init(values:temp)
                        XCTAssertEqual(dbObject, object,"Error: Failed to insert object in DB.")
                    }
                }
                else {
                    XCTFail("Error: Failed to create the statement.")
                    return
                }
            }
            else {
                XCTFail("Error occured while opening DB.")
            }
        }
        catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
    
    func testOptionalInsertOperation() {
        let object = TestingObject(integer: 123, string: "ABC", optionalInt: nil, flag: true)
        sut.insert(insertObject: object)
        do {
            let dbURL: URL
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = documentDirectory.appendingPathComponent(sqliteFileName).appendingPathExtension("sqlite")
            var db: OpaquePointer? = nil
            if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
                print("Successfully opened connection to database at \(dbURL).")
                defer {
                    if sqlite3_close(db) == SQLITE_OK {
                        print("DB closed successfully.")
                    }
                }
                let readTableQuery = """
                SELECT * FROM \(tableName) WHERE Id=123
                """
                var statement: OpaquePointer? = nil
                defer {
                    sqlite3_finalize(statement)
                }
                if sqlite3_prepare_v2(db, readTableQuery, -1, &statement, nil) == SQLITE_OK {
                    if sqlite3_step(statement) == SQLITE_ROW {
                        var temp: [Any] = []
                        temp.append(sqlite3_column_int(statement, 0))
                        let stringResult = sqlite3_column_text(statement, 1)
                        temp.append(String(cString: stringResult!))
                        temp.append(sqlite3_column_int(statement, 2))
                        temp.append(sqlite3_column_int(statement, 3))
                        let dbObject = TestingObject.init(values:temp)
                        XCTAssertEqual(dbObject, object,"Error: Failed to insert object in DB.")
                    }
                }
                else {
                    XCTFail("Error: Failed to create the statement.")
                }
            }
            else {
                XCTFail("Error occured while opening DB.")
            }
        }
        catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }

    func testQueryOperation() {
        do {
            let object = TestingObject(integer: 222, string: "BBB", optionalInt: 34, flag: true)
            let dbURL: URL
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = documentDirectory.appendingPathComponent(sqliteFileName).appendingPathExtension("sqlite")
            var db: OpaquePointer? = nil
            if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
                print("Successfully opened connection to database at \(dbURL).")
                defer {
                    if sqlite3_close(db) == SQLITE_OK {
                        print("DB closed successfully.")
                    }
                }
                let insertTableQuery = """
                INSERT INTO \(tableName) (Id, String, Optional, Flag) VALUES (?, ?, ?, ?);
                """
                var statement: OpaquePointer? = nil
                defer {
                    sqlite3_finalize(statement)
                }
                if sqlite3_prepare_v2(db, insertTableQuery, -1, &statement, nil) == SQLITE_OK {
                    let values = object.getValues()
                    sqlite3_bind_int(statement, 1, values[0] as! Int32)
                    sqlite3_bind_text(statement, 2, (values[1] as! NSString).utf8String, -1, nil)
                    sqlite3_bind_int(statement, 3, values[2] as! Int32)
                    sqlite3_bind_int(statement, 4, values[3] as! Int32)
                    if sqlite3_step(statement) != SQLITE_DONE {
                        XCTFail("Error: Failed to insert object in DB for testing.")
                    }
                    let dbObjects = sut.query(query: "String='BBB'")
                    if let dbObjects = dbObjects {
                        if dbObjects.count > 0 {
                            XCTAssertEqual(dbObjects[0], object,"Error: Failed to insert object in DB.")
                        }
                        else {
                            XCTFail("Error: Failed to get object from DB.")
                        }
                    }
                    else {
                        XCTFail("Error: Failed to get object from DB.")
                    }
                }
                else {
                    XCTFail("Error: Failed to create the statement for testing.")
                }
            }
            else {
                XCTFail("Error occured while opening DB.")
            }
        }
        catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
    
    func testReadOperation() {
        do {
            let object = TestingObject(integer: 222, string: "BBB", optionalInt: 34, flag: true)
            let dbURL: URL
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = documentDirectory.appendingPathComponent(sqliteFileName).appendingPathExtension("sqlite")
            var db: OpaquePointer? = nil
            if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
                print("Successfully opened connection to database at \(dbURL).")
                defer {
                    if sqlite3_close(db) == SQLITE_OK {
                        print("DB closed successfully.")
                    }
                }
                let insertTableQuery = """
                INSERT INTO \(tableName) (Id, String, Optional, Flag) VALUES (?, ?, ?, ?);
                """
                var statement: OpaquePointer? = nil
                defer {
                    sqlite3_finalize(statement)
                }
                if sqlite3_prepare_v2(db, insertTableQuery, -1, &statement, nil) == SQLITE_OK {
                    let values = object.getValues()
                    sqlite3_bind_int(statement, 1, values[0] as! Int32)
                    sqlite3_bind_text(statement, 2, (values[1] as! NSString).utf8String, -1, nil)
                    sqlite3_bind_int(statement, 3, values[2] as! Int32)
                    sqlite3_bind_int(statement, 4, values[3] as! Int32)
                    if sqlite3_step(statement) != SQLITE_DONE {
                        XCTFail("Error: Failed to insert object in DB for testing.")
                    }
                    let dbObject = sut.read(id: "222")
                    XCTAssertEqual(dbObject, object,"Error: Failed to insert object in DB.")
                }
                else {
                    XCTFail("Error: Failed to create the statement for testing.")
                }
            }
            else {
                XCTFail("Error occured while opening DB.")
            }
        }
        catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
    
    func testSearchAbsentElement() {
        let dbObject = sut.read(id: "333")
        if dbObject != nil {
            XCTFail("Incorrect object fetched.")
        }
        XCTAssert(true)
    }
    
    func testDeleteOperation() {
        do {
            let object = TestingObject(integer: 444, string: "CCC", optionalInt: 56, flag: true)
            let dbURL: URL
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = documentDirectory.appendingPathComponent(sqliteFileName).appendingPathExtension("sqlite")
            var db: OpaquePointer? = nil
            if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
                print("Successfully opened connection to database at \(dbURL).")
                defer {
                    if sqlite3_close(db) == SQLITE_OK {
                        print("DB closed successfully.")
                    }
                }
                let insertTableQuery = """
                INSERT INTO \(tableName) (Id, String, Optional, Flag) VALUES (?, ?, ?, ?);
                """
                var statement: OpaquePointer? = nil
                defer {
                    sqlite3_finalize(statement)
                }
                if sqlite3_prepare_v2(db, insertTableQuery, -1, &statement, nil) == SQLITE_OK {
                    let values = object.getValues()
                    sqlite3_bind_int(statement, 1, values[0] as! Int32)
                    sqlite3_bind_text(statement, 2, (values[1] as! NSString).utf8String, -1, nil)
                    sqlite3_bind_int(statement, 3, values[2] as! Int32)
                    sqlite3_bind_int(statement, 4, values[3] as! Int32)
                    if sqlite3_step(statement) == SQLITE_DONE {
                        sut.delete(query: "Id=444")
                        let readTableQuery = """
                        SELECT * FROM \(tableName) WHERE Id=444
                        """
                        var newStatement: OpaquePointer? = nil
                        defer {
                            sqlite3_finalize(newStatement)
                        }
                        if sqlite3_prepare_v2(db, readTableQuery, -1, &newStatement, nil) == SQLITE_OK {
                            if sqlite3_step(newStatement) == SQLITE_ROW {
                                XCTFail("Delete operation failed.")
                            }
                            XCTAssert(true)
                        }
                        else {
                            XCTFail("Error: Failed to create the statement.")
                            return
                        }
                    }
                    else {
                        XCTFail("Error: Failed to insert object in DB for testing.")
                    }
                }
                else {
                    XCTFail("Error: Failed to create the statement for testing.")
                }
            }
            else {
                XCTFail("Error occured while opening DB.")
            }
        }
        catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
}
