//
//  Observable.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/02/16.
//

import Foundation

struct Observable<T> {
    var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    mutating func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
