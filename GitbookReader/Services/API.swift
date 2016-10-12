//
//  API.swift
//  GitbookReader
//
//  Created by Calvin on 10/11/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import Moya

let endpointClosure = { (target: CapsLockGitBook) -> Endpoint<CapsLockGitBook> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let endpoint: Endpoint<CapsLockGitBook> = Endpoint<CapsLockGitBook>(URL: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
    
    // Sign all non-authenticating requests
    switch target {
    case .userBooks, .user:
        return endpoint.adding(newHttpHeaderFields: ["Authentication-Token": UserViewModel.sharedInstance.token ?? ""])
    default:
        return endpoint
    }
}

let CapsLockGitBookProvider = RxMoyaProvider<CapsLockGitBook>(endpointClosure: endpointClosure, plugins:  [NetworkLoggerPlugin(verbose: true)])

enum CapsLockGitBook {
    case starredBooks(String)
    case userBooks
    case user
}

extension CapsLockGitBook: TargetType {
    public var baseURL: URL { return URL(string: Application.AssociatedDomain.current.value)! }
    public var path: String {
        switch self {
        case .starredBooks(let username):
            return "/users/\(username)/starred"
        case .userBooks:
            return "/books"
        case .user:
            return "/users"
        }
        
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        switch self {
        case .starredBooks, .userBooks, .user:
            return nil
        }
    }
    public var task: Task {
        return .request
    }
    
    public var sampleData: Data {
        switch self {
        case .starredBooks:
            return "[{\"id\":\"test\",\"author\":\"calvin-huang\",\"title\":\"Test book for GitBookReader\",\"description\":\"iOS repo - https://github.com/Calvin-Huang/GitbookReader-iOS\\r\\nRails repo - https://github.com/Calvin-Huang/GitbookReader\\r\\nThis repo will not remove for unit test,\"}]".data(using: .utf8)!
        default:
            return "".data(using: .utf8)!
        }
    }
}
