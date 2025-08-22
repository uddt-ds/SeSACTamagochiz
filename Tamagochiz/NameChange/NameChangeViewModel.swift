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
    }

    init(currentNickname: String) {
        nickname = currentNickname
    }

    func transform(input: Input) -> Output {

        let newNickname = PublishSubject<String>()

        // TODO: 조건 예외처리 들어가야함
        input.saveButtonTapped
            .withLatestFrom(input.nicknameText)
            .bind(with: self) { owner, value in
                newNickname.onNext(value)
            }
            .disposed(by: disposeBag)

        return Output(nicknameResult: newNickname)
    }
}
