//
//  ViewModelType.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/14/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
//

import Combine

public protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func perform(_ input: Input, cancelBag: CancelBag) -> Output
}


