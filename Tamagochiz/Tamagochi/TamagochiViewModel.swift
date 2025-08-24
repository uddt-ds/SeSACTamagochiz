//
//  TamagochiViewModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TamagochiViewModel: RxViewModelProtocol {

    let tamagochiData: [TamagochiModel] = [
        TamagochiModel(tamaCategory: .tama1, name: "따끔따끔 다마고치", image: "1-6"),
        TamagochiModel(tamaCategory: .tama2, name: "방실방실 다마고치", image: "2-6"),
        TamagochiModel(tamaCategory: .tama3, name: "반짝반짝 다마고치", image: "3-6")
    ]

    var tamagochi: TamaCategory = .tama1 {
        didSet {
            UserDefaults.standard.set(tamagochi.rawValue, forKey: "tamagochi")
        }
    }

    var disposeBag = DisposeBag()

    struct Input {
        let viewDidLoadTrigger: PublishRelay<Void>
    }

    struct Output {
        let tamagochiRawData: BehaviorRelay<[TamagochiModel]>
    }

    func transform(input: Input) -> Output {

        let totalCount = 21
        let totalData = tamagochiData + Array(repeating: TamagochiModel(tamaCategory: .isReady, name: "준비 중이에요", image: "noImage"), count: totalCount - tamagochiData.count)

        let tamagochiRawData = BehaviorRelay(value: totalData)

        input.viewDidLoadTrigger
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                tamagochiRawData.accept(owner.tamagochiData)
            }
            .disposed(by: disposeBag)

        return Output(tamagochiRawData: tamagochiRawData)
    }
}
