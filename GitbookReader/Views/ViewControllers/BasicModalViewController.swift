//
//  BasicModalViewController.swift
//  GitbookReader
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasicModalViewController: UIViewController, Modal {
    @IBOutlet var container: UIView!
    @IBOutlet var header: UIView!
    @IBOutlet var body: UIView!
    @IBOutlet var footer: UIView!
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBOutlet var messageLabel: UILabel! {
        didSet {
            messageLabel.text = message
        }
    }
    
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var confirmButton: UIButton! {
        didSet {
            confirmButton.layer.borderWidth = 1.0
            confirmButton.layer.borderColor = confirmButton.titleColor(for: .normal)?.cgColor
        }
    }
    @IBOutlet var cancelButton: UIButton!
    
    var confirmed: ((AnyObject?) -> Void)?
    var canceled: (() -> Void)?
    
    var message: String? {
        didSet {
            guard let label = messageLabel else {
                return
            }
            
            label.text = message
        }
    }
    
    private let disposeBag = DisposeBag()
    private let modalTransition = ModalTransition()
    
    private let userViewModel = UserViewModel.sharedInstance
    
    // MARK: Initializers
    convenience init(title: String? = "", message: String? = "", confirmed: ((AnyObject?) -> Void)? = nil, canceled: (() -> Void)? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        setUpDefaultValues()
        
        self.title = title
        self.message = message
        self.confirmed = confirmed
        self.canceled = canceled
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setUpDefaultValues()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpDefaultValues()
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                })
            .addDisposableTo(disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    
                    // Make sure animate done.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                        self?.canceled?()
                    }
                })
                })
            .addDisposableTo(disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.userViewModel.authenticateGitBook()
                self?.confirmed?(self)
                })
            .addDisposableTo(disposeBag)
        
        // Can not override title action, observe title and trigger set label.
        self.rx
            .observe(String.self, "title")
            .filter({ [weak self] _ -> Bool in
                
                // Prevent label released
                guard let _ = self?.messageLabel else {
                    return false
                }
                
                return true
                })
            .subscribe(onNext: { [weak self] (title) in
                self?.messageLabel.text = title
                })
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private Methods
    private func setUpDefaultValues() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = modalTransition
    }
}
