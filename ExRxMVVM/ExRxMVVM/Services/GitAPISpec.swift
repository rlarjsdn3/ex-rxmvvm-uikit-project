//
//  GitAPISpec.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - API Header
protocol APIHeader {
    var key: String { get }
    var value: String { get }
}

// MARK: - API Parameter
protocol APIParameter {
    var key: String { get }
    var value: Any? { get }
}

// MARK: - API Config
protocol APIConfigType {
    var hostApi: String { get }
}

struct APIConfig: APIConfigType {
    var hostApi: String = "https://api.github.com"
}

// MARK: - API
enum API {
    private static let _config: APIConfigType = APIConfig()
    static let hostApi: String = _config.hostApi
    
    // MARL: - Common Headers
    enum Header: APIHeader {
        case contentJson
        
        var key: String {
            switch self {
            case .contentJson: return "Content-Type"
            }
        }
        
        var value: String {
            switch self {
            case .contentJson: return "application/json"
            }
        }
        
        static var baseHeaders: [Self] {
            return [.contentJson]
        }
    }
}

// MARK: - API Spec
struct APISpec {
    let method: HTTPMethod
    let url: String
    
    init(method: HTTPMethod, url: String) {
        self.method = method
        self.url = url
    }
}

// MARK: - Git API
protocol APIs {
    var spec: APISpec { get }
}

enum GitAPIs: APIs {
    case repositorySearch(query: String)
    
    var spec: APISpec {
        switch self {
        case let .repositorySearch(query):
            return APISpec(method: .get, url: "\(API.hostApi)/search/repositories?q=\(query)")
        }
    }
}
