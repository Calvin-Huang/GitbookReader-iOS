//
//  Modal.swift
//  GitbookReader
//
//  Created by Calvin on 10/11/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import Foundation

protocol Modal {
    var confirmed: (() -> Void)? { get set }
    var canceled: (() -> Void)? { get set }
}
