//
//  NameChangeViewModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NameChangeViewModel: RxViewModelProtocol {

    var disposeBag = DisposeBag()

    var nickname: String

    struct Input {
        // textField로부터 받아올 값
        let nicknameText: ControlProperty<String>
        let saveButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let nicknameResult: PublishSubject<String>
        let validateResult: PublishSubject<String>
        let validateError: PublishSubject<String>
    }

    init(currentNickname: String) {
        nickname = currentNickname
    }

    func transform(input: Input) -> Output {

        let newNickname = PublishSubject<String>()

        let validateResult = PublishSubject<String>()
        let validateError = PublishSubject<String>()

        input.saveButtonTapped
            .throttle(.milliseconds(5), scheduler: MainScheduler.instance)
            .withLatestFrom(input.nicknameText)
            .map { $0.count >= 2 && $0.count <= 6 }
            .map { $0 ? "" : "닉네임은 2글자 이상, 6글자 이하로만 설정해야해요" }
            .bind(with: self) { owner, value in
                validateError.onNext(value)
            }
            .disposed(by: disposeBag)

        input.saveButtonTapped
            .throttle(.milliseconds(5), scheduler: MainScheduler.instance)
            .withLatestFrom(input.nicknameText)
            .bind(with: self) { owner, value in
                validateResult.onNext(value)
            }
            .disposed(by: disposeBag)

        return Output(nicknameResult: newNickname, validateResult: validateResult, validateError: validateError)
    }
}
