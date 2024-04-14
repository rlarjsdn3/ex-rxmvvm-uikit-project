//
//  ViewControllerType.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

import RxSwift

private struct AssociatedKeys {
    static var viewModel = "viewModel"
}

protocol ViewControllerType: AnyObject {
    associatedtype ViewModel: ViewModelType
    
    var disposeBag: DisposeBag { get set }
    
    var viewModel: ViewModel? { get set }
    
    func bind(viewModel: ViewModel)
}

extension ViewControllerType {
    private var underlyingViewModel: ViewModel? {
        get {
            return objc_getAssociatedObject(
                self,
                &AssociatedKeys.viewModel
            ) as? ViewModel
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.viewModel,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    var viewModel: ViewModel? {
        get {
            guard let viewModel = underlyingViewModel else {
                fatalError("ViewModel has not been set")
            }
            return viewModel
        }
        set {
            disposeBag = DisposeBag()
            if let vm = newValue {
                bind(viewModel: vm)
            }
            underlyingViewModel = newValue
        }
    }
}
