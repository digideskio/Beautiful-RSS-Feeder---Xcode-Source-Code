//
//  FeedDataHelper.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 03/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import Foundation
import SQLite

protocol DataHelperProtocol {
    typealias T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?
}

class FeedDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Feeds"
    static let table = Table(TABLE_NAME)
    static let id = Expression<Int64> ("id")
    static let name = Expression<String> ("name")
    static let address = Expression<String> ("address")
    
    typealias T = Feed
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_error
        }
        do {
            let _ = try DB.run(table.create(ifNotExists: true) { t in
                t.column (id, primaryKey: .Autoincrement)
                t.column(name)
                t.column(address)
            })
        } catch _ {
            //error handling if table exists
        }
    }
    
    static func deleteFeedsTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_error
        }
        do {
            let _ = try DB.run(table.drop(ifExists: true))
            let _ = try createTable()
        } catch _ {
            //error handling if table exists
        }
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_error
        }
        if (item.name != nil && item.address != nil) {
            let insert = table.insert(name <- item.name!, address <- item.address!)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            }
            catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
    }
    
    static func delete(item: T) throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            print("connection failed")
            throw DataAccessError.Datastore_Connection_error
        }
        let query = table.filter(id == item.getId())
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                print("query delete failed 1")
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            print("query delete failed 2")
            throw DataAccessError.Delete_Error
        }
    }
    
    static func find(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_error
        }
        
        let query = table.filter(self.id == id)
        do {
            let items = DB.prepare(query)
        
            for item in items {
                return Feed(id: item[self.id], name: item[name], address: item[address])
            }
        }
        return nil
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_error
        }
        var retArray = [T]()
        let items = DB.prepare(table)
        for item in items {
            retArray.append(Feed(id: item[id], name: item[name], address: item[address])!)
        }
        retArray.sortInPlace { (Feed1, Feed2) -> Bool in
            if Feed1.getId() < Feed2.getId() {
                return true
            }
            else {
                return false
            }
        }
        return retArray
    }
    
    
}
























