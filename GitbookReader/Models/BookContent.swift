//
//  BookContent.swift
//  GitbookReader
//
//  Created by Calvin on 10/8/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RealmSwift

class BookContent: Object {
    dynamic var level: String = ""
    dynamic var filePath: String = ""
    dynamic var title: String = ""
    dynamic var content: String = ""
    dynamic var read: Bool = false
    dynamic var readProgress: Float = 0
}
