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
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
}
