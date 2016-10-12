//
//  Book.swift
//  GitbookReader
//
//  Created by Calvin on 10/8/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RealmSwift
import ObjectMapper

class Book: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var author: String = ""
    dynamic var bid: String = ""
    dynamic var title: String = ""
    dynamic var summary: String = ""
    
    let contents = List<BookContent>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        author <- map["author"]
        bid <- map["bid"]
        title <- map["title"]
        summary <- map["description"]
    }
    
    override static func primaryKey() -> String? {
        return "bid"
    }
}
