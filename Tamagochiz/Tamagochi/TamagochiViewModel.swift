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
        TamagochiModel(tamaCategory: .tama1, name: "따끔따끔 다마고치", image: "1-6", tamaMessage: "저는 따끔따끔 다마고치입니당 키는 100km 몸무게는 100톤이에요 성격은 따끔합니다 골라주시면 감사해요"),
        TamagochiModel(tamaCategory: .tama2, name: "방실방실 다마고치", image: "2-6", tamaMessage: "저는 방실방실 다마고치입니당 키는 100km 몸무게는 150톤이에요 성격은 화끈하고 날라다닙니당~! 열심히 잘 먹고 잘 클 자신은 있답니다 방실방실!"),
        TamagochiModel(tamaCategory: .tama3, name: "반짝반짝 다마고치", image: "3-6", tamaMessage: "저는 반짝반짝 다마고치에요 키는 10km 몸무게는 12톤이에요 속도는 아주 빨라요!")
    ]

    var tamagochi: TamaCategory = .tama1 {
        didSet {
            UserDefaults.standard.set(tamagochi.rawValue, forKey: UserDefaultsKey.tamagochi.rawValue)
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
        let totalData = tamagochiData + Array(repeating: TamagochiModel(tamaCategory: .isReady, name: "준비 중이에요", image: "noImage", tamaMessage: "nonTitle"), count: totalCount - tamagochiData.count)

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
