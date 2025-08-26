//
//  BoxOfficeViewModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/26/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel: RxViewModelProtocol {

    var disposeBag = DisposeBag()

    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchBarText: ControlProperty<String>
    }

    struct Output {
        let boxOfficeData: PublishRelay<[DailyBoxOfficeResult]>
        let showToast: PublishRelay<Bool>
    }

    func transform(input: Input) -> Output {

        let boxOfficeData = PublishRelay<[DailyBoxOfficeResult]>()
        let showAlert = PublishRelay<Bool>()

        input.searchButtonClicked
            .withLatestFrom(input.searchBarText)
            .flatMap { BoxOfficeCustomObservable.getBoxOfficeSingleData(query: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    boxOfficeData.accept(data)
                case .failure(let error):
                    showAlert.accept(true)
                }
            }
            .disposed(by: disposeBag)

        return Output(boxOfficeData: boxOfficeData, showToast: showAlert)
    }

}
