//
//  Observable+Ext.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

import RxSwift

extension Observable where Element == Data {
    
    func decode<T>(of type: T.Type) -> Observable<T> where T: Decodable {
        flatMap { element in
            Observable<T>.create { observer in
                do {
                    let decoder = JSONDecoder()
                    let parsing = try decoder.decode(type, from: element)
                    observer.onNext(parsing)
                } catch {
                    observer.onError(RxSwift.RxError.noElements)
                }
                
                return Disposables.create()
            }
        }
    }
    
}
