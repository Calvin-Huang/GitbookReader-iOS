//
//  Bootstrap.swift
//  GitbookReader
//
//  Created by Calvin on 10/11/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import Foundation

struct Application {
    enum AssociatedDomain {
        case production
        case development
        
        static var current: AssociatedDomain {
            #if DEBUG
                return .development
            #else
                return .production
            #endif
        }
        
        var value: String {
            guard let mainSetting = Bundle.main.object(forInfoDictionaryKey: "Associated Domain") as AnyObject? else {
                assertionFailure("Must have Associated Domain - Production")
                return ""
            }
            
            switch self {
            case .development:
                guard let returnValue = mainSetting["Development"] as? String else {
                    assertionFailure("Must have Associated Domain - Development")
                    return ""
                }
                
                return returnValue
                
            case .production:
                guard let returnValue = mainSetting["Production"] as? String else {
                    assertionFailure("Must have Associated Domain - Production")
                    return ""
                }
                
                return returnValue   
            }
        }
    }
    
    static var allowedPaths: [String] {
        guard let allowedPaths = Bundle.main.object(forInfoDictionaryKey: "Allowed Paths") as? [String] else {
            return []
        }
        
        return allowedPaths
    }
    
    static func isAllowed(path: String) -> Bool {
        return allowedPaths.contains(path)
    }
}
