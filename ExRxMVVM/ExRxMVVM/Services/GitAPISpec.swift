//
//  GitAPISpec.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

protocol APISpec {
    var url: URL? { get }
}

enum GitAPISpec: APISpec {
    case repositorySearch(query: String)
    
    var url: URL? {
        switch self {
        case let .repositorySearch(query):
            return URL(string: "https://api.github.com/search/repositories?q=\(query)")
        }
    }
}
