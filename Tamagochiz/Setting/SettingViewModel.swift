//
//  SettingViewModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel: RxViewModelProtocol {

    var disposeBag = DisposeBag()

    private let tableViewTitleData = SettingTableViewTitle.allCases
    private let tableViewImageData = SettingTableViewImage.allCases

    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }

    struct Output {
        let tableViewData: BehaviorSubject<[TableViewDataModel]>
    }


    func transform(input: Input) -> Output {

        let tableViewData: BehaviorSubject<[TableViewDataModel]> = BehaviorSubject(value: [])

        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                var dataArr: [TableViewDataModel] = []

                let imageData = owner.tableViewImageData.map { $0.rawValue }
                let data = owner.tableViewTitleData.map { $0.rawValue }

                for i in 0..<data.count {
                    let nickname = UserDefaultsManager.nickname
                    let tableViewData = TableViewDataModel(nickname: nickname, image: imageData[i], title: data[i])
                    dataArr.append(tableViewData)
                }

                tableViewData.onNext(dataArr)
            }
            .disposed(by: disposeBag)
        
        return Output(tableViewData: tableViewData)
    }
}

extension SettingViewModel {

    enum SettingTableViewTitle: String, CaseIterable {
        case nameSet = "내 이름 설정하기"
        case tamagochiChange = "다마고치 변경하기"
        case resetData = "데이터 초기화"
    }

    enum SettingTableViewImage: String, CaseIterable {
        case pencil
        case moonFill = "moon.fill"
        case arrowClockwise = "arrow.clockwise"
    }
}
