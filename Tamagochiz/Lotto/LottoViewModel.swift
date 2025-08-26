//
//  LottoViewModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/26/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LottoViewModel: RxViewModelProtocol {

    var disposeBag = DisposeBag()

    struct Input {
        let buttonTap: ControlEvent<Void>
        let textFieldText: ControlProperty<String>
    }

    struct Output {
        let lottoResult: PublishRelay<String>
        let toastMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {
        let lottoResult = PublishRelay<String>()
        let toastMessage = PublishRelay<String>()

        input.buttonTap
            .withLatestFrom(input.textFieldText)
            .compactMap { Int($0) }
            .flatMap { number -> Observable<Int> in
                if number < 0 || number > 1187 {
                    toastMessage.accept("회차 정보를 잘못 입력했습니다")
                    return .empty()
                }
                return .just(number)
            }
            .flatMap { number in
                CustomObservable.fetchLottoResultData(query: "\(number)")
                    .catch { _ in
                        return Observable.never()
                    }
            }
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let lotto):
                    lottoResult.accept(lotto.totalTitle)
                case .failure(let error):
                    toastMessage.accept(error.title)
                }
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        return Output(lottoResult: lottoResult, toastMessage: toastMessage)
    }


}
