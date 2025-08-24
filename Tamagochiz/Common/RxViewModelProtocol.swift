//
//  RxViewModelProtocol.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import Foundation
import RxSwift

protocol RxViewModelProtocol {
    var disposeBag: DisposeBag { get set }
    
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
