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

    let dateFormatter = DateFormatter()

    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchBarText: ControlProperty<String>
    }

    struct Output {
        let boxOfficeData: PublishRelay<[DailyBoxOfficeResult]>
        let alertMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let boxOfficeData = PublishRelay<[DailyBoxOfficeResult]>()
        let alertMessage = PublishRelay<String>()


        input.searchButtonClicked
            .withLatestFrom(input.searchBarText)
            .map { self.checkValidate(input: $0) }
            .flatMap { value in
                switch value {
                case .success(let query):
                    return BoxOfficeCustomObservable.getBoxOfficeSingleData(query: query)
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    boxOfficeData.accept(data)
                case .failure(let error):
                    switch error {
                    case .failDecoding:
                        alertMessage.accept(error.title)
                    case .noData:
                        alertMessage.accept(error.title)
                    case .serverError(let message):
                        alertMessage.accept(message)
                    default:
                        alertMessage.accept(error.title)
                    }
                }
            }
            .disposed(by: disposeBag)

        return Output(boxOfficeData: boxOfficeData, alertMessage: alertMessage)
    }

    private func checkValidate(input: String) -> Result<String, NetworkError> {
        dateFormatter.dateFormat = "YYYYMMDD"
        let date = dateFormatter.date(from: input)
        if date == nil {
            return .failure(.queryError)
        }
        return .success(input)
    }

}
