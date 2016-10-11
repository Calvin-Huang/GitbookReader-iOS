//
//  UserViewModel.swift
//  GitbookReader
//
//  Created by Calvin on 10/10/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RxSwift

class UserViewModel {
    let currentUser: Variable<User?> = Variable(nil)
    
    static let sharedInstance = UserViewModel()
    
    private init() {}
    
    func authenticateGitBook() {
        guard let associatedDomain = (Bundle.main.object(forInfoDictionaryKey: "Associated Domain") as AnyObject?)?["Production"] as? String else {
            return
        }
        UIApplication.shared.openURL(URL(string: "\(associatedDomain)/users/auth/gitbook")!)
    }
    
    func fetchUser(token: String) {
        
    }
}
