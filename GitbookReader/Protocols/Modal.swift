//
//  Modal.swift
//  GitbookReader
//
//  Created by Calvin on 10/11/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

protocol Modal: Confirmable {
    var container: UIView! { get set }
    var header: UIView! { get set }
    var body: UIView! { get set }
    var footer: UIView! { get set }
    
    var dismissButton: UIButton! { get set }
    var confirmButton: UIButton! { get set }
    var cancelButton: UIButton! { get set }
}
