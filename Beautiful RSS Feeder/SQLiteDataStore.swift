//
//  SQLiteDataStore.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 02/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import Foundation
import SQLite

enum DataAccessError: ErrorType {
    case Datastore_Connection_error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
}

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let BBDB: Connection?
    
    private init() {
        var path = "db.sqlite"
        
        if let dirs: [NSString] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [NSString] {
            let dir = dirs[0]
            path = dir.stringByAppendingPathComponent("db.sqlite");
            print(path)
        }
        
        do {
            BBDB = try Connection (path)
        }
        catch _ {
            BBDB = nil
        }
    }
    
    func createTables () throws {
        do {
            try FeedDataHelper.createTable ()
        } catch {
            throw DataAccessError.Datastore_Connection_error
        }
    }
}