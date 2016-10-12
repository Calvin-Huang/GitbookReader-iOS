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
    
    var queuedAction: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    private lazy var actionSheet: UIAlertController = {
        let actionSheet = UIAlertController(title: "You can add book by", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(
            UIAlertAction(title: "Enter remote URL", style: .default, handler: { [weak self] _ in
                self?.present(AddBookViewController(), animated: true, completion: nil)
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(title: "Search in gitbook.com", style: .default, handler: { [weak self] _ in
                self?.present(SearchBookViewController(), animated: true, completion: nil)
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(title: "Import from your stars", style: .default, handler: { [weak self] _ in
                let userViewModel = UserViewModel.sharedInstance
                if let user = userViewModel.currentUser.value {
                    userViewModel.fetchStarrdBooks()
                } else {
                    let authenticateViewController = AuthenticateModalViewController(
                        confirmed: { [weak self] in
                            guard let viewController = $0 as? UIViewController else {
                                return
                            }
                            
                            self?.queuedAction = { self?.showImportBookFromStarsHintModal() }
                            viewController.dismiss(animated: false)
                        }
                    )
                    
                    self?.present(authenticateViewController, animated: true, completion: nil)
                }
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        
        return actionSheet
    }()
    private lazy var importBookFromStarsHintModal: BasicModalViewController = {
        let modalViewController = BasicModalViewController(
            message: "You can add books from your starred!",
            confirmed: {
                guard let viewController = $0 as? UIViewController else { return }
                
                UserViewModel.sharedInstance.fetchStarrdBooks()
                
                viewController.dismiss(animated: true, completion: nil)
            }
        )
        
        return modalViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        configureKeyboardDismissesOnScroll()
        configureBooksTable()
        
        addBookButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if let _ = UserViewModel.sharedInstance.currentUser.value {
                    self?.showAddBookActionSheet()
                } else {
                    let authenticateViewController = AuthenticateModalViewController(
                        confirmed: { [weak self] in
                            guard let viewController = $0 as? UIViewController else {
                                return
                            }
                            
                            self?.queuedAction = { self?.showAddBookActionSheet() }
                            viewController.dismiss(animated: false)
                        },
                        canceled: { [weak self] in
                            self?.showAddBookActionSheet()
                        }
                    )
                    
                    self?.present(authenticateViewController, animated: true, completion: nil)
                }
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
    
    func showAddBookActionSheet() {
        self.present(self.actionSheet, animated: true, completion: nil)
    }
    
    func showImportBookFromStarsHintModal() {
        self.present(self.importBookFromStarsHintModal, animated: true, completion: nil)
    }

    // MARK: Private Methods
    private func configureBooksTable() {
        booksTable.register(UINib(nibName: "\(BookCell.self)", bundle: nil), forCellReuseIdentifier: "\(BookCell.self)")
        booksTable.rowHeight = 74
        
        UserViewModel.sharedInstance.ownedBooks
            .asObservable()
            .bindTo(booksTable.rx.items(cellIdentifier: "\(BookCell.self)", cellType: BookCell.self)) { (row, viewModel, cell) in
                cell.viewModel = viewModel
            }
            .addDisposableTo(disposeBag)
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
