//
//  AuthenticateModalViewController.swift
//  GitbookReader
//
//  Created by Calvin on 10/11/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DynamicColor

class AuthenticateModalViewController: UIViewController, Modal {
    @IBOutlet var container: UIView!
    @IBOutlet var header: UIView!
    @IBOutlet var body: UIView!
    @IBOutlet var footer: UIView!
    
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
    
    private let disposeBag = DisposeBag()
    private let modalTransition = ModalTransition()
    
    private let userViewModel = UserViewModel.sharedInstance
    
    // MARK: Initializers
    convenience init(confirmed: ((AnyObject?) -> Void)? = nil, canceled: (() -> Void)? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        setUpDefaultValues()
        
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
