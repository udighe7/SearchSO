//
//  dbUtil.swift
//  SearchSO
//
//  Created by utkarsh on 19/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
    case Close(message: String)
}

struct dbUtil {
    let dbURL: URL
    let queue: DispatchQueue
    
    func openDB() throws -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(self.dbURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.dbURL)")
        }
        else {
            throw SQLiteError.OpenDatabase(message: "Error occured while opening DB.")
        }
        return db
    }
    
    func closeDB(_ db: OpaquePointer?) throws {
        if sqlite3_close(db) == SQLITE_OK {
            print("DB closed successfully.")
        }
        else {
            throw SQLiteError.Close(message: "Error occured while closing DB.")
        }
    }
    
    func prepareStatement(db: OpaquePointer?, sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK
            else {
                throw SQLiteError.Prepare(message: "Error occured while preparing SQL statement.")
        }
        
        return statement
    }
    
    func createTable(table: Table) throws {
        try queue.sync {
            let dbPointer: OpaquePointer? = try self.openDB()
            defer {
                do {
                    try self.closeDB(dbPointer)
                }
                catch SQLiteError.Close(let message) {
                    print(message)
                }
                catch {
                    print(error)
                }
            }
            let createTableStatement = try prepareStatement(db: dbPointer, sql: table.createQuery)
            defer {
                sqlite3_finalize(createTableStatement)
            }
            guard sqlite3_step(createTableStatement) == SQLITE_DONE
                else {
                    throw SQLiteError.Step(message: "Error occurred while creating table \(table.tableName)")
            }
            print("\(table) table created.")
        }
    }
    
    func insertInTable(table: Table, values: [Any]) throws {
        try queue.sync {
            let dbPointer: OpaquePointer? = try self.openDB()
            defer {
                do {
                    try self.closeDB(dbPointer)
                }
                catch SQLiteError.Close(let message) {
                    print(message)
                }
                catch {
                    print(error)
                }
            }
            let insertTableStatement = try prepareStatement(db: dbPointer, sql: table.insertQuery)
            defer {
                sqlite3_finalize(insertTableStatement)
            }
            var index = 0
            for value in values {
                if table.columnTypes[index] == "CHAR" {
                    sqlite3_bind_text(insertTableStatement, Int32(index+1), (value as AnyObject).utf8String, -1, nil)
                }
                else if table.columnTypes[index] == "INT" {
                    sqlite3_bind_int(insertTableStatement, Int32(index+1), value as! Int32)
                }
                index += 1
            }
            guard sqlite3_step(insertTableStatement) == SQLITE_DONE
                else {
                    throw SQLiteError.Step(message: "Error occured while inserting in table \(table.tableName)")
            }
            print("Successfully inserted row.")
        }
    }
    
    func readFromTable(table: Table, columnIndexes: [Int], completion: @escaping ([Any]?) -> Void) {
        queue.sync {
            do {
                let dbPointer: OpaquePointer? = try self.openDB()
                defer {
                    do {
                        try self.closeDB(dbPointer)
                    }
                    catch SQLiteError.Close(let message) {
                        print(message)
                    }
                    catch {
                        print(error)
                    }
                }
                let readTableStatement = try prepareStatement(db: dbPointer, sql: table.readQuery)
                defer {
                    sqlite3_finalize(readTableStatement)
                }
                var results: [Any] = []
                while sqlite3_step(readTableStatement) == SQLITE_ROW {
                    var temp: [Any] = []
                    for index in 0..<columnIndexes.count {
                        if table.columnTypes[columnIndexes[index]] == "CHAR" {
                            let stringResult = sqlite3_column_text(readTableStatement, Int32(index+1))
                            temp.append(String(cString: stringResult!))
                        }
                        else if table.columnTypes[columnIndexes[index]] == "INT" {
                            temp.append(sqlite3_column_int(readTableStatement, Int32(index+1)))
                        }
                    }
                    results.append(temp)
                }
                completion(results)
            }
            catch {
                print(error)
                let tempResult: [Any]? = nil
                completion(tempResult)
            }
        }
    }
}

extension dbUtil {
    init?(name: String) {
        do {
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            self.dbURL = documentDirectory.appendingPathComponent(name).appendingPathExtension("sqlite")
            self.queue = DispatchQueue(label: "dbQueue", qos: DispatchQoS.utility)
        }
        catch {
            print(error)
            return nil
        }
    }
}
