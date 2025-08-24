//
//  MainViewModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

/*
 1. UserDefaults Raw하게 다루기
 2. 저장하는 시점을 언제로 하는게 좋을까? (바로 저장? View가 내려갈때 저장?)
 3.
 */
final class MainViewModel/*: RxViewModelProtocol */{
    
    var disposeBag = DisposeBag()

    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let feedTextField: ControlProperty<String>
        let waterTextField: ControlProperty<String>
        let feedButtonTapped: ControlEvent<Void>
        let waterButtonTapped: ControlEvent<Void>
    }

    struct Output {
//        let userData: BehaviorRelay<UserModel>
        let feedCount: BehaviorRelay<Int>
        let waterCount: BehaviorRelay<Int>
        let totalResult: BehaviorRelay<String>
        let tamagochiMessage: BehaviorRelay<String>
        let feedErrorMessage: BehaviorRelay<String>
        let waterErrorMessage: BehaviorRelay<String>
    }

//    func transform(input: Input) -> Output {
//
////        let userData = BehaviorRelay<UserModel>(value: .init(nickname: "", level: 0, foodCount: 0, waterCount: 0))
//        let feedCount = BehaviorRelay<Int>(value: 0)
//        let waterCount = BehaviorRelay<Int>(value: 0)
//        let feedErrorMessage = BehaviorRelay<String>(value: "")
//        let waterErrorMessage = BehaviorRelay<String>(value: "")
//        let totalResult = BehaviorRelay<String>(value: "")
//        let greetingMessage = BehaviorRelay<String>(value: "")
//
//        // TODO: 버튼을 눌렀을 때마다 방출되는 값을 view에 binding해야 함
//        // TODO:
//        input.viewDidLoadTrigger
//            .bind(with: self) { owner, _ in
//
//            }
//            .disposed(by: disposeBag)
//
////        input.viewDidLoadTrigger
////            .withUnretained(self)
////            .map { owner, _ in
////
////            }
////            .asDriver(onErrorJustReturn: "")
////            .drive(with: self) { owner, value in
////                totalResult.accept(value)
////                print("totalResult", value)
////            }
////            .disposed(by: disposeBag)
////
////        input.feedButtonTapped
////            .withUnretained(self)
////            .map { owner, _ in
////
////            }
////            .asDriver(onErrorJustReturn: "")
////            .drive(with: self) { owner, value in
////                totalResult.accept(value)
////                print("totalResult", value)
////            }
////            .disposed(by: disposeBag)
//
//        input.feedButtonTapped
//            .withLatestFrom(input.feedTextField)
//            .compactMap { Int($0) }
//            .map { !($0 > 0 && $0 < 100) }
//            .map { $0 ? "밥은 한번에 99개까지만 먹일 수 있어요" : "" }
//            .asDriver(onErrorJustReturn: "")
//            .drive(with: self) { owner, value in
//                feedErrorMessage.accept(value)
//            }
//            .disposed(by: disposeBag)
//
//        input.waterButtonTapped
//            .withLatestFrom(input.waterTextField)
//            .compactMap { Int($0) }
//            .map { !($0 > 0 && $0 < 50) }
//            .map { $0 ? "물은 한번에 49개까지만 먹일 수 있어요" : "" }
//            .asDriver(onErrorJustReturn: "")
//            .drive(with: self) { owner, value in
//                waterErrorMessage.accept(value)
//            }
//            .disposed(by: disposeBag)
//
//        input.feedButtonTapped
//            .withLatestFrom(input.feedTextField)
//            .map{ Int($0) ?? 1 }
//            .filter { $0 > 0 && $0 < 100 }
//            .asDriver(onErrorJustReturn: 0)
//            .drive(with: self) { owner, value in
//                print(value)
//
//            }
//            .disposed(by: disposeBag)
//
//        input.waterButtonTapped
//            .withLatestFrom(input.waterTextField)
//            .map { Int($0) ?? 1 }
//            .filter { $0 > 0 && $0 < 50 }
//            .asDriver(onErrorJustReturn: 0)
//            .drive(with: self) { owner, value in
//                waterCount.accept(value)
//            }
//            .disposed(by: disposeBag)
//
//        input.viewDidLoadTrigger
////            .map {  }
//            .asDriver(onErrorJustReturn: ())
//            .drive(with: self) { owner, _ in
//
//            }
//            .disposed(by: disposeBag)
//
//
//
//        return Output(userData: userData, feedCount: feedCount, waterCount: waterCount, totalResult: totalResult, tamagochiMessage: greetingMessage, feedErrorMessage: feedErrorMessage, waterErrorMessage: waterErrorMessage)
//    }

}
