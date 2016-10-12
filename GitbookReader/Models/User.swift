//
//  User.swift
//  GitbookReader
//
//  Created by Calvin on 10/10/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import ObjectMapper
import RealmSwift

class User: Object, Mappable {
    dynamic var uid: String = ""
    dynamic var username: String = ""
    dynamic var token: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        uid <- map["uid"]
        username <- map["username"]
        token <- map["token"]
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
