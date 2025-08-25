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


    private var tamagochi = UserDefaultsManager.tamagochi

    private var tamagochiName = UserDefaultsManager.tamagochiName
    var nickname = UserDefaultsManager.nickname
    private var level = UserDefaultsManager.level
    private var food = UserDefaultsManager.food
    private var water = UserDefaultsManager.water

    private var messageDb: [String] = []

    init() {
        loadData()

//        if let data = UserDefaults.standard.data(forKey: "tamagochiModel") {
//            if let decodedData = try? JSONDecoder().decode(TamagochiModel.self, from: data) {
//                tamagochiModel = decodedData
//            }
//        }

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
        let viewDidLoadTrigger: Observable<Void>
        let foodTextField: ControlProperty<String>
        let waterTextField: ControlProperty<String>
        let foodButtonTapped: ControlEvent<Void>
        let waterButtonTapped: ControlEvent<Void>
    }

    struct Output {
//        let userData: BehaviorRelay<UserModel>
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

        let foodCount = BehaviorRelay(value: 0)
        let waterCount = BehaviorRelay(value: 0)
        let levelCount = BehaviorRelay(value: 0)
        let tamagochiRawValue = BehaviorRelay(value: 0)
        let tamagochiName = BehaviorRelay(value: "")
        let tamagochiMessage = BehaviorRelay(value: "")
        let foodErrorMessage = PublishRelay<String>()
        let waterErrorMessage = PublishRelay<String>()
        let totalReulstLabel = BehaviorRelay(value: "")

        input.viewDidLoadTrigger
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                foodCount.accept(owner.food)
                waterCount.accept(owner.water)
                levelCount.accept(owner.level)
                tamagochiRawValue.accept(owner.tamagochi)
                tamagochiName.accept(owner.tamagochiName)
                tamagochiMessage.accept(owner.messageDb.randomElement() ?? "")
            }
            .disposed(by: disposeBag)

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
                "밥 줘서 고마워요 \(owner.nickname)님"
            }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                tamagochiMessage.accept(value)
            }
            .disposed(by: disposeBag)

        foodValue
            .bind(with: self) { owner, value in
                owner.food += value
                UserDefaultsManager.setData(owner.food, key: .food)
                foodCount.accept(owner.food)
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
                    waterErrorMessage.accept("물은 1 ~ 99까지만 먹을 수 있어요")
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
                "물 줘서 고마워요 \(owner.nickname)님"
            }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                tamagochiMessage.accept(value)
            }
            .disposed(by: disposeBag)

        waterValue
            .bind(with: self) { owner, value in
                owner.water += value
                UserDefaultsManager.setData(owner.water, key: .water)
                waterCount.accept(owner.water)
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
                owner.level = value
                UserDefaultsManager.setData(owner.level, key: .level)
                levelCount.accept(value)
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(foodCount.asObservable(), waterCount.asObservable(), levelCount.asObservable())
            .withUnretained(self)
            .map { owner, result in
                "LV\(result.2) • 밥알 \(result.0)개 • 물방울 \(result.1)개"
            }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                totalReulstLabel.accept(value)
            }
            .disposed(by: disposeBag)

        tamaValue
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, value in
                tamagochiRawValue.accept(value)
                UserDefaultsManager.setData(owner.tamagochi, key: .tamagochi)
            }
            .disposed(by: disposeBag)

        return Output(foodCount: foodCount, waterCount: waterCount, levelCount: levelCount, tamagochiRawValue: tamagochiRawValue, tamagochiName: tamagochiName, tamagochiMessage: tamagochiMessage, foodErrorMessage: foodErrorMessage, waterErrorMessage: waterErrorMessage, totalResultLabel: totalReulstLabel)
    }

    func loadData() {
        tamaValue.accept(tamagochi)
    }
}
