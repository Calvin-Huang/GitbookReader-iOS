//
//  UISearchBar.swift
//  GitbookReader
//
//  Created by Calvin on 10/10/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {
    var firstResponder: AnyObserver<Bool> {
        return UIBindingObserver(UIElement: self.base) { (searchBar, shouldBecameResponder) in
            if shouldBecameResponder {
                searchBar.becomeFirstResponder()
            } else {
                searchBar.resignFirstResponder()
            }
            }.asObserver()
    }
}
