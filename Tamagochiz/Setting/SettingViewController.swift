//
//  SettingViewController.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingViewController: UIViewController {

    private let viewModel = SettingViewModel()

    var disposeBag = DisposeBag()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: SettingViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }

    private func configureHierarchy() {
        [tableView].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func configureView() {
        view.backgroundColor = .white
    }

    private func bind() {
        let input = SettingViewModel.Input(viewDidLoadTrigger: Observable.just(()))
        let output = viewModel.transform(input: input)

        output.tableViewData
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.identifier) as? SettingViewCell else { return .init() }

                //TODO: 이 판단 로직 VM으로 옮기기
                if row == 0 {
                    cell.configureCell(with: element, isHidden: false)
                } else {
                    cell.configureCell(with: element, isHidden: true)
                }
                return cell
            }
            .disposed(by: disposeBag)


        // Merge는 타입이 불일치해서 불가능
        Observable.zip(tableView.rx.modelSelected(TableViewDataModel.self), tableView.rx.itemSelected)
            .bind(with: self) { owner, result in
                switch result.1.row {
                case 0:
                    let viewModel = NameChangeViewModel(currentNickname: result.0.nickname)
                    let vc = NameChangeViewController(viewModel: viewModel)
                    owner.navigationController?.pushViewController(vc, animated: true)
                case 1: // TODO: 다마고치 변경화면
                    print("다마고치 화면 tapped")
                case 2: // TODO: 알럿 띄우고 확인 누르면 UserDefault 데이터 다 0으로 만들고 다마고치 선택화면 push
                    print("데이터 초기화 tapped")
                default:
                    return
                }
            }
            .disposed(by: disposeBag)

//        tableView.rx.modelSelected(TableViewDataModel.self)
//            .bind(with: self) { owner, data in
//                let viewModel = NameChangeViewModel(currentNickname: data.nickname)
//                let vc = NameChangeViewController(viewModel: viewModel)
//                owner.navigationController?.pushViewController(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
//
//        tableView.rx.itemSelected
//            .bind(with: self) { owner, indexPath in
//                switch indexPath.row {
//                case 0:
//                    let viewModel = NameChangeViewModel(currentNickname: "ㅇㅇ")
//                    let vc = NameChangeViewController(viewModel: viewModel)
//                    owner.navigationController?.pushViewController(vc, animated: true)
//                case 1: // TODO: 다마고치 변경 화면
//                    let vc = ViewController()
//                    owner.navigationController?.pushViewController(vc, animated: true)
//                case 2:    // TODO: UserDefault 다 0으로 만들고, 닉네임 설정화면으로 Push
//                    let vc = ViewController()
//                    owner.navigationController?.pushViewController(vc, animated: true)
//                default:
//                    return
//                }
//            }
//            .disposed(by: disposeBag)
    }
}
