//
//  MainViewModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: RxViewModelProtocol {

    var disposeBag = DisposeBag()

    let userDefaultData = UserDefaultsStore.userData

    // UserDefault 전체 데이터 만들기
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let feedTextField: ControlProperty<String>
        let waterTextField: ControlProperty<String>
        let feedButtonTapped: ControlEvent<Void>
        let waterButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let userData: BehaviorRelay<UserModel>
        let feedCount: BehaviorRelay<Int>
        let waterCount: BehaviorRelay<Int>
        let totalResult: BehaviorRelay<String>
        let tamagochiMessage: BehaviorRelay<String>
    }

    func transform(input: Input) -> Output {

        let userData = BehaviorRelay<UserModel>(value: .init(nickname: "", level: 0, foodCount: 0, waterCount: 0))
        let feedCount = BehaviorRelay<Int>(value: 0)
        let waterCount = BehaviorRelay<Int>(value: 0)
        let feedErrorMessage = BehaviorRelay<String>(value: "")
        let waterErrorMessage = BehaviorRelay<String>(value: "")
        let totalResult = BehaviorRelay<String>(value: "")
        let greetingMessage = BehaviorRelay<String>(value: "")

        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                userData.accept(owner.userDefaultData)
            }
            .disposed(by: disposeBag)

        input.viewDidLoadTrigger
            .withUnretained(self)
            .map { owner, _ in
                owner.userDefaultData.nickname
            }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                totalResult.accept(value)
            }
            .disposed(by: disposeBag)

        input.feedButtonTapped
            .withLatestFrom(input.feedTextField)
            .compactMap { Int($0) }
            .map { $0 == 0 || $0 > 100 }
            .map { $0 ? "" : "밥은 한번에 99개까지만 먹일 수 있어요" }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                feedErrorMessage.accept(value)
            }
            .disposed(by: disposeBag)

        input.waterButtonTapped
            .withLatestFrom(input.waterTextField)
            .compactMap { Int($0) }
            .map { $0 == 0 || $0 > 50 }
            .map { $0 ? "" : "밥은 한번에 49개까지만 먹일 수 있어요" }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                waterErrorMessage.accept(value)
            }
            .disposed(by: disposeBag)

        input.feedButtonTapped
            .withLatestFrom(input.feedTextField)
            .map{ Int($0) ?? 0 }
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, value in
                feedCount.accept(value)
            }
            .disposed(by: disposeBag)

        input.waterButtonTapped
            .withLatestFrom(input.waterTextField)
            .map { Int($0) ?? 0 }
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, value in
                waterCount.accept(value)
            }
            .disposed(by: disposeBag)

        input.viewDidLoadTrigger
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                greetingMessage.accept(value)
            }
            .disposed(by: disposeBag)


        return Output(userData: userData, feedCount: feedCount, waterCount: waterCount, totalResult: totalResult, tamagochiMessage: greetingMessage)
    }

}
