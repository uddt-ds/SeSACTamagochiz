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

    private var messageDb: [String] = []

    init() {
        loadData()

        let nickname = UserDefaultsManager.getData().nickname

        messageDb = [#"\#(nickname)님,\#n복습 하셨나요?"#,
        #"\#(nickname)님,\#n깃허브 푸시하셨나요?"#,
        #"\#(nickname)님,\#n5시 칼퇴하실건가요?"#,
        #"\#(nickname)님,\#n배고파요 밥주세요"#,
        #"잘 챙겨주셔서 레벨업 했어요!\#n\#(nickname)님"#,
        "밥 먹으니까 졸려요"]
    }

    let foodValue = BehaviorRelay(value: 0)
    let waterValue = BehaviorRelay(value: 0)
    let levelValue = BehaviorRelay(value: 0)
    let tamaValue = BehaviorRelay(value: 0)
    let tamaName = BehaviorRelay(value: "")

    struct Input {
        let foodTextField: ControlProperty<String>
        let waterTextField: ControlProperty<String>
        let foodButtonTapped: ControlEvent<Void>
        let waterButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let foodCount: BehaviorRelay<Int>
        let waterCount: BehaviorRelay<Int>
        let levelCount: BehaviorRelay<Int>
        let tamagochiRawValue: BehaviorRelay<Int>
        let tamagochiName: BehaviorRelay<String>
        let tamagochiMessage: BehaviorRelay<String>
        let foodErrorMessage: PublishRelay<String>
        let waterErrorMessage: PublishRelay<String>
        let totalResultLabel: BehaviorRelay<String>
    }

    func transform(input: Input) -> Output {

        let userData = UserDefaultsManager.getData()
        let foodCount = BehaviorRelay(value: userData.food)
        let waterCount = BehaviorRelay(value: userData.water)
        let levelCount = BehaviorRelay(value: userData.level)
        let tamagochiRawValue = BehaviorRelay(value: userData.tamagochi)
        let tamagochiName = BehaviorRelay(value: userData.tamagochiName)
        let tamagochiMessage = BehaviorRelay(value: messageDb.randomElement() ?? "")
        let foodErrorMessage = PublishRelay<String>()
        let waterErrorMessage = PublishRelay<String>()
        let totalReulstLabel = BehaviorRelay(value: "")

        input.foodButtonTapped
            .withLatestFrom(input.foodTextField)
            .map { $0.isEmpty ? "1" : $0 }
            .compactMap { Int($0) }
            .withUnretained(self)
            .flatMap { owner, value -> Observable<Int> in
                if value > -1 && value < 100 {
                    return .just(value)
                } else {
                    foodErrorMessage.accept("밥은 1 ~ 99까지만 먹을 수 있어요")
                    return .empty()
                }
            }
            .bind(with: self) { owner, value in
                owner.foodValue.accept(value)
            }
            .disposed(by: disposeBag)

        input.foodButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                "밥 줘서 고마워요 \(UserDefaultsManager.getData().nickname)님"
            }
            .bind(with: self) { owner, value in
                tamagochiMessage.accept(value)
            }
            .disposed(by: disposeBag)

        foodValue
            .bind(with: self) { owner, value in
                UserDefaultsManager.updateData { data in
                    data.food += value
                    foodCount.accept(data.food)
                }
            }
            .disposed(by: disposeBag)

        input.waterButtonTapped
            .withLatestFrom(input.waterTextField)
            .map { $0.isEmpty ? "1" : $0 }
            .compactMap { Int($0) }
            .withUnretained(self)
            .flatMap { owner, value -> Observable<Int> in
                if value > -1 && value < 50 {
                    return .just(value)
                } else {
                    waterErrorMessage.accept("물은 1 ~ 49까지만 먹을 수 있어요")
                    return .empty()
                }
            }
            .bind(with: self) { owner, value in
                owner.waterValue.accept(value)
            }
            .disposed(by: disposeBag)

        input.waterButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                "물 줘서 고마워요 \(UserDefaultsManager.getData().nickname)님"
            }
            .bind(with: self) { owner, value in
                tamagochiMessage.accept(value)
            }
            .disposed(by: disposeBag)

        waterValue
            .bind(with: self) { owner, value in
                UserDefaultsManager.updateData { data in
                    data.water += value
                    waterCount.accept(data.water)
                }
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(foodCount.asObservable(), waterCount.asObservable())
            .map { result in
                let calculate = ((Double(result.0) / 5.0) + (Double(result.1) / 2.0)) * 0.1
                let calculateResult = Int(calculate)
                if calculateResult == 0 {
                    return 1
                } else if calculateResult >= 10 {
                    return 10
                } else {
                    return calculateResult
                }
            }
            .bind(with: self) { owner, value in
                UserDefaultsManager.updateData { data in
                    data.level = value
                    levelCount.accept(data.level)
                }
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(foodCount.asObservable(), waterCount.asObservable(), levelCount.asObservable())
            .withUnretained(self)
            .map { owner, result in
                "LV\(result.2) • 밥알 \(result.0)개 • 물방울 \(result.1)개"
            }
            .bind(with: self) { owner, value in
                totalReulstLabel.accept(value)
            }
            .disposed(by: disposeBag)

        tamaValue
            .bind(with: self) { owner, value in
                UserDefaultsManager.updateData { data in
                    data.tamagochi = value
                    tamagochiRawValue.accept(value)
                }
            }
            .disposed(by: disposeBag)

        return Output(foodCount: foodCount,
                      waterCount: waterCount,
                      levelCount: levelCount,
                      tamagochiRawValue: tamagochiRawValue,
                      tamagochiName: tamagochiName,
                      tamagochiMessage: tamagochiMessage,
                      foodErrorMessage: foodErrorMessage,
                      waterErrorMessage: waterErrorMessage,
                      totalResultLabel: totalReulstLabel)
    }

    func loadData() {
        tamaValue.accept(UserDefaultsManager.getData().tamagochi)
    }
}
