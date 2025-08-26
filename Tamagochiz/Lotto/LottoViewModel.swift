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
        let showAlert: PublishRelay<Bool>
    }

    func transform(input: Input) -> Output {
        let lottoResult = PublishRelay<String>()
        let showAlert = PublishRelay<Bool>()

        input.buttonTap
            .withLatestFrom(input.textFieldText)
            .flatMap{ text in
                CustomObservable.fetchLottoResultData(query: text)
                    .catch { _ in
                        return Observable.never()
                    }
            }
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let lotto):
                    lottoResult.accept(lotto.totalTitle)
                case .failure(let error):
                    showAlert.accept(true)
                }
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        return Output(lottoResult: lottoResult, showAlert: showAlert)
    }


}
