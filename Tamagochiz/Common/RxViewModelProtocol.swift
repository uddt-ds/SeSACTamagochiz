//
//  RxViewModelProtocol.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import Foundation

protocol RxViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
