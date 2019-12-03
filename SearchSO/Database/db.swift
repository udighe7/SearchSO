//
//  db.swift
//  SearchSO
//
//  Created by utkarsh on 27/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Close(message: String)
}

struct db {
    let dbURL: URL
    
    init?(name: String) {
        do {
            let documentDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            self.dbURL = documentDirectory.appendingPathComponent(name).appendingPathExtension("sqlite")
        }
        catch {
            print(error)
            return nil
        }
    }
    
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
}
