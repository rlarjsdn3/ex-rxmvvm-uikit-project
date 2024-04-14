//
//  APIService.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

import RxSwift

// MARK: - APIWorker
protocol APIWorker {
    func request(_ spec: APISpec) -> Observable<Data>
}

extension APIWorker {
    func request(_ spec: APISpec) -> Observable<Data> {
        guard let url = URL(string: spec.url) else {
            return .empty()
        }
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
    }
}

// MARK: - Git APIWorker
typealias GitAPIWorker = GitAPIs.Worker
extension GitAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(qos: .utility)
        }()
    }
}

extension GitAPIWorker {
    func fetchRepositorySearch(_ query: String) -> Observable<[Item]> {
        let spec = GitAPIs.repositorySearch(query: query).spec
        
        return request(spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0, encoding: .utf8) {
                    debugPrint("Respository Search Result: \(str)")
                }
            }
            .decode(of: Repository.self)
            .map { $0.items }
            .catchAndReturn([])
    }
}
