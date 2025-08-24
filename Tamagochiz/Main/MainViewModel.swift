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

    var nickname: String = "대장" {
        didSet {
            UserDefaults.standard.set(nickname, forKey: "nickname")
        }
    }
    var level: Int = 0 {
        didSet {
            UserDefaults.standard.set(level, forKey: "level")
        }
    }
    var food: Int = 0 {
        didSet {
            UserDefaults.standard.set(food, forKey: "food")
        }
    }

    var water: Int = 0 {
        didSet {
            UserDefaults.standard.set(water, forKey: "water")
        }
    }

    init() {
        loadData()
    }

    let foodValue = BehaviorRelay(value: 0)
    let waterValue = BehaviorRelay(value: 0)
    let levelValue = BehaviorRelay(value: 0)

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
        let tamagochiMessage: BehaviorRelay<String>
        let foodErrorMessage: BehaviorRelay<String>
        let waterErrorMessage: BehaviorRelay<String>
        let totalResultLabel: BehaviorRelay<String>
    }

    func transform(input: Input) -> Output {

        let foodCount = BehaviorRelay(value: 0)
        let waterCount = BehaviorRelay(value: 0)
        let levelCount = BehaviorRelay(value: 0)
        let tamagochiMessage = BehaviorRelay(value: "")
        let foodErrorMessage = BehaviorRelay(value: "")
        let waterErrorMessage = BehaviorRelay(value: "")
        let totalReulstLabel = BehaviorRelay(value: "")

        input.viewDidLoadTrigger
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                foodCount.accept(owner.food)
                waterCount.accept(owner.water)
                levelCount.accept(owner.level)
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
                waterCount.accept(owner.water)
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(foodCount.asObservable(), waterCount.asObservable())
            .map { result in
                let calculate = ((Double(result.0) / 5.0) + (Double(result.1) / 2.0)) * 0.1
                let calculateResult = Int(calculate)
                print(calculateResult)
                return calculateResult
            }
            .bind(with: self) { owner, value in
                owner.level = value
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


        return Output(foodCount: foodCount, waterCount: waterCount, levelCount: levelCount, tamagochiMessage: tamagochiMessage, foodErrorMessage: foodErrorMessage, waterErrorMessage: waterErrorMessage, totalResultLabel: totalReulstLabel)
    }

    func loadData() {
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? "기본값"
        level = UserDefaults.standard.integer(forKey: "level")
        food = UserDefaults.standard.integer(forKey: "food")
        water = UserDefaults.standard.integer(forKey: "water")
    }
}
