//
//  DataModels.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 02/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import Foundation

//holds feeds
class Feed {
    
    var id: Int64?
    var name: String?
    var address: String?
    
    init? (id: Int64, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
        
        if name.isEmpty || address.isEmpty {
            return nil
        }
    }
    
    func getName () -> String {
        return name!
    }
    func getId () -> Int64 {
        return id!
    }
    func getAddress () -> String {
        return address!
    }
}

class FeedItem {
    
    var title: String
    var description: String
    var link: String
    var feedName: String
    var feedAddress: String
    
    init (title: String, description: String, link: String, feedName: String, feedAddress: String) {
        self.title = title;
        self.description = description
        self.link = link
        self.feedName = feedName
        self.feedAddress = feedAddress
    }
    
    func getTitle () -> String {
        return title
    }
    func getDescription () -> String {
        return description
    }
    func getLink () -> String {
        return link
    }
    func getFeedName () -> String {
        return feedName
    }
    func getFeedAddress () -> String {
        return feedAddress
    }
}







