//
//  UserViewModel.swift
//  GitbookReader
//
//  Created by Calvin on 10/10/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RxSwift
import Moya_ObjectMapper
import RealmSwift

class UserViewModel {
    let currentUser: Variable<User?> = Variable(nil)
    let ownedBooks: Variable<[BookViewModel]> = Variable([BookViewModel]())
    
    let disposeBag = DisposeBag()
    
    var token: String? {
        didSet {
            CapsLockGitBookProvider.request(.user)
                .mapObject(User.self)
                .subscribe(onNext: { [weak self] (user: User) in
                    self?.currentUser.value = user
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.create(User.self, value: user, update: true)
                    }
                })
                .addDisposableTo(disposeBag)
        }
    }
    
    static let sharedInstance = UserViewModel()
    
    private init() {
        let realm = try! Realm()
        
        currentUser.value = realm.objects(User.self).first
        ownedBooks.value = realm.objects(Book.self).map { BookViewModel(with: $0) }
        token = currentUser.value?.token
    }
    
    func authenticateGitBook() {
        UIApplication.shared.openURL(URL(string: "\(Application.AssociatedDomain.production.value)/users/auth/gitbook")!)
    }
    
    func fetchStarrdBooks() {
        guard let user = self.currentUser.value else { return }
        
        CapsLockGitBookProvider.request(.starredBooks(user.username))
            .mapArray(Book.self)
            .subscribe(onNext: { [weak self] (books) in
                
                // Save to local storage.
                DispatchQueue(label: "background").async {
                    let realm = try! Realm()
                    try! realm.write {
                        books.forEach({ (book) in
                            realm.create(Book.self, value: book, update: true)
                        })
                    }
                }
                
                self?.ownedBooks.value = books.map { BookViewModel(with: $0) }
            })
            .addDisposableTo(disposeBag)
    }
}
