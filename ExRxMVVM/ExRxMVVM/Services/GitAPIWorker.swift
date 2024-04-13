//
//  APIService.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

import RxSwift

protocol APIWorker {
    func request(_ spec: APISpec) -> Observable<Data>
}

extension APIWorker {
    func request(_ spec: APISpec) -> Observable<Data> {
        guard let url = spec.url else { return .empty() }
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
    }
}

final class GitAPIWorker: APIWorker {
    
    func fetchRepositorySearch(_ query: String) -> Observable<Data> {
        let spec = GitAPISpec.repositorySearch(query: query)
        
        return request(spec)
    }
    
}
