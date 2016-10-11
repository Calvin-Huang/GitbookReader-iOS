//
//  BootstrapSpec.swift
//  GitbookReader
//
//  Created by Calvin on 10/11/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import Quick
import Nimble

@testable import GitbookReader

class BootstrapSpec: QuickSpec {
    override func spec() {
        context("Application - Bootstrap file defines application settings") {
            describe("#AssociatedDomain") {
                it("current associated domain should be development") {
                    expect(Application.AssociatedDomain.current).to(equal(Application.AssociatedDomain.development))
                }
                
                it("should have correct values") {
                    expect(Application.AssociatedDomain.production.value).to(equal("https://api.capslock.tw"))
                    expect(Application.AssociatedDomain.development.value).to(equal("http://localhost:3000"))
                }
            }
            
            describe(".allowedPaths") {
                it("should allow path - /users") {
                    expect(Application.allowedPaths.contains("/users")).to(be(true))
                }
                
                it("quick check method should work") {
                    expect(Application.isAllowed(path: "/users")).to(be(true))
                }
            }
        }
    }
}
