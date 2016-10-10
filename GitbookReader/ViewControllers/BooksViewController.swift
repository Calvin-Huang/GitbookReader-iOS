//
//  BooksViewController.swift
//  GitbookReader
//
//  Created by Calvin on 6/20/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DynamicColor

class BooksViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var addBookButton: UIButton!
    @IBOutlet var booksTable: UITableView! {
        didSet {
            booksTable.tableFooterView = UIView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Private Methods
    private func configureBooksTable() {
        
    }
    
    private func configureKeyboardDismissesOnScroll() {
        booksTable.rx.contentOffset
    }
}
