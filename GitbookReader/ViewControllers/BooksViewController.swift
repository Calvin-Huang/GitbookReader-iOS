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
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var booksTable: UITableView! {
        didSet {
            booksTable.tableFooterView = UIView()
        }
    }
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        configureKeyboardDismissesOnScroll()
        
        addBookButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.present(AuthenticateModalViewController(), animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        
        let cancelTapDriver = cancelButton.rx.tap.asDriver()
        
        cancelTapDriver
            .map { false }
            .drive(searchBar.rx.firstResponder)
            .addDisposableTo(disposeBag)

        cancelTapDriver
            .map { "" }
            .drive(searchBar.rx.text)
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Private Methods
    private func configureBooksTable() {
        
    }
    
    private func configureSearchBar() {
        let startEditingDriver = searchBar.rx.textDidBeginEditing.asDriver()
        
        startEditingDriver.map { true } .drive(addBookButton.rx.hidden).addDisposableTo(disposeBag)
        startEditingDriver.map { true } .drive(cancelButton.rx.enabled).addDisposableTo(disposeBag)
        
        let endEditingDriver = searchBar.rx.textDidEndEditing.asDriver()
        
        endEditingDriver.map { false } .drive(addBookButton.rx.hidden).addDisposableTo(disposeBag)
        endEditingDriver.map { false } .drive(cancelButton.rx.enabled).addDisposableTo(disposeBag)
    }
    
    private func configureKeyboardDismissesOnScroll() {
        booksTable.rx.contentOffset
            .asDriver()
            .map { _ in false }
            .drive(searchBar.rx.firstResponder)
            .addDisposableTo(disposeBag)
    }
}
