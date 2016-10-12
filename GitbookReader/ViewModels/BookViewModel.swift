//
//  BookViewModel.swift
//  GitbookReader
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RxSwift

struct BookViewModel {
    let book: Book

    init(with book: Book) {
        self.book = book
    }
}
