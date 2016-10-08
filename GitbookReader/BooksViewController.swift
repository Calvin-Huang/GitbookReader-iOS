//
//  BooksViewController.swift
//  GitbookReader
//
//  Created by Calvin on 6/20/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit
import RxSwift

class BooksViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var addBookButton: UIButton!
    @IBOutlet var booksTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Private Methods
    fileprivate func configureNavigationBar() {
        
    }
}
