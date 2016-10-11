//
//  UserViewModel.swift
//  GitbookReader
//
//  Created by Calvin on 10/10/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RxSwift

class UserViewModel {
    let currentUser: Observable<User?> = Observable.just(nil)
}
