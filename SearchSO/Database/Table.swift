//
//  Table.swift
//  SearchSO
//
//  Created by utkarsh on 20/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation
import SQLite3

struct Table<A: TableInsertable> {
    let tableName: String
    let columns: [Column]
    let dbPath: db?
    
    init(tableName: String, columns: [Column], sqlFileName: String) {
        self.tableName = tableName
        self.columns = columns
        
        self.dbPath = db(name: sqlFileName)
        guard let db = self.dbPath
        else {
            print("Failed to create table")
            return
        }
        do {
            let dbPointer: OpaquePointer? = try db.openDB()
            defer {
                do {
                    try db.closeDB(dbPointer)
                }
                catch {
                    print(error)
                }
            }
            var createTableQuery = "CREATE TABLE IF NOT EXISTS "
            createTableQuery += tableName
            createTableQuery += "( "
            var count = 0
            for column in columns {
                createTableQuery += column.name + " "
                createTableQuery += column.type.rawValue + " "
                createTableQuery += column.constraint
                if count != columns.count - 1 {
                    createTableQuery += ", "
                }
                else {
                    createTableQuery += ");"
                }
                count += 1
            }
            
            let createTableStatement = try db.prepareStatement(db: dbPointer, sql: createTableQuery)
            defer {
                sqlite3_finalize(createTableStatement)
            }
            guard sqlite3_step(createTableStatement) == SQLITE_DONE
            else {
                print("Error occurred while creating table \(tableName)")
                return
            }
            print("If table didn't exists, it was created successfully!")
        }
        catch {
            print(error)
        }
    }
    
    func insert(insertObject: A) {
        let insertValues = insertObject.getValues()
        guard let db = self.dbPath
        else {
            print("Failed to insert in table")
            return
        }
        do {
            let dbPointer: OpaquePointer? = try db.openDB()
            defer {
                do {
                    try db.closeDB(dbPointer)
                }
                catch {
                    print(error)
                }
            }
            var insertStatementQuery = "INSERT INTO "
            insertStatementQuery += tableName + " ("
            var neededValues = "("
            for index in 0..<columns.count {
                if columns[index].constraint != "AUTO_INCREMENT" {
                    if index != columns.count - 1 {
                        insertStatementQuery += columns[index].name + ", "
                        neededValues += "?, "
                    }
                    else {
                        insertStatementQuery += columns[index].name + ") "
                        neededValues += "?)"
                    }
                }
            }
            insertStatementQuery += "VALUES " + neededValues + ";"
            
            let insertTableStatement = try db.prepareStatement(db: dbPointer, sql: insertStatementQuery)
            defer {
                sqlite3_finalize(insertTableStatement)
            }
            
            var count = 0
            for column in columns {
                if column.constraint != "AUTO_INCREMENT" {
                    if column.type == .string {
                        sqlite3_bind_text(insertTableStatement, Int32(count+1), (insertValues[count] as! NSString).utf8String, -1, nil)
                    }
                    else if column.type == .integer {
                        if let flag = insertValues[count] as? Bool {
                            if flag {
                                sqlite3_bind_int(insertTableStatement, Int32(count+1), 1)
                            }
                            else {
                                sqlite3_bind_int(insertTableStatement, Int32(count+1), 0)
                            }
                        }
                        else {
                            sqlite3_bind_int(insertTableStatement, Int32(count+1), insertValues[count] as! Int32)
                        }
                    }
                    count += 1
                }
            }
            guard sqlite3_step(insertTableStatement) == SQLITE_DONE
            else {
                print("Error occurred while inserting in table \(tableName)")
                return
            }
            print("Row inserted successfully!")
        }
        catch {
            print(error)
        }
    }

    func query(query:String) -> [A]? {
        // use query passed here as where clause
        // id = 1 and text = ios
        var results: [A] = []
        if query.contains("Id=") && (query.firstIndex(of: "=") == query.lastIndex(of: "=")) {
            let index = query.index(after: query.firstIndex(of: "=")!)
            if let object = read(id: String(query[index...])) {
                results.append(object)
            }
            return results
        }
        else {
            guard let db = self.dbPath
            else {
                print("Failed to read in table")
                return nil
            }
            do {
                let dbPointer: OpaquePointer? = try db.openDB()
                defer {
                    do {
                        try db.closeDB(dbPointer)
                    }
                    catch {
                        print(error)
                    }
                }
                var readStatementQuery = "SELECT * FROM "
                readStatementQuery += tableName + " WHERE "
                readStatementQuery += query + ";"
                
                let readTableStatement = try db.prepareStatement(db: dbPointer, sql: readStatementQuery)
                defer {
                    sqlite3_finalize(readTableStatement)
                }
                while sqlite3_step(readTableStatement) == SQLITE_ROW {
                    var temp: [Any] = []
                    for index in 0..<columns.count {
                        if columns[index].type == .string {
                            let stringResult = sqlite3_column_text(readTableStatement, Int32(index))
                            temp.append(String(cString: stringResult!))
                        }
                        else if columns[index].type == .integer {
                            temp.append(sqlite3_column_int(readTableStatement, Int32(index)))
                        }
                    }
                    if let object = A.init(values:temp) {
                        results.append(object)
                    }
                }
                return results
            }
            catch {
                print(error)
                return nil
            }
        }
    }
    
    func read(id:String) -> A? {
        // read is special case of query
            // query ("id = \(myId)")
        return self.query(query: "Id = \(id)")?.first
    }
    
    func delete(query: String) {
        guard let db = self.dbPath
        else {
            print("Failed to insert in table")
            return
        }
        do {
            let dbPointer: OpaquePointer? = try db.openDB()
            defer {
                do {
                    try db.closeDB(dbPointer)
                }
                catch {
                    print(error)
                }
            }
            var deleteStatementQuery = "DELETE FROM "
            deleteStatementQuery += tableName + " WHERE "
            deleteStatementQuery += query + ";"
            
            let deleteStatement = try db.prepareStatement(db: dbPointer, sql: deleteStatementQuery)
            defer {
                sqlite3_finalize(deleteStatement)
            }
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Rows satisfying condition deleted successfully!")
            }
            else {
                print("Error occured while deleting rows")
            }
        }
        catch {
            print(error)
        }
    }
    
}
