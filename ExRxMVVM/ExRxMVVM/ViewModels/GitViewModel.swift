//
//  ViewModel.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

import RxSwift
import RxCocoa

final class GitViewModel: ViewModelType {
    
    // MARK: - Input
    struct Input {
        var inputText: Observable<String>
    }
    
    // MARK: - Output
    struct Output {
        var totalCount: Driver<Int>
        var repositories: Driver<[Item]>
    }
    
    // MARK: - Properties
    private let apiWorker = GitAPIWorker()
    
    // MARK: - Transform
    func transform(_ input: Input) -> Output {
        let repositories = input.inputText
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .flatMapLatest {
                self.apiWorker.fetchRepositorySearch($0)
            }
            .debug()
            .asDriver(onErrorJustReturn: [])
        
        let totalCount = repositories
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(
            totalCount: totalCount,
            repositories: repositories
        )
    }
    
}
