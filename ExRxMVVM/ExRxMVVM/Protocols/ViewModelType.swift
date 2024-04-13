//
//  ViewModelType.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
