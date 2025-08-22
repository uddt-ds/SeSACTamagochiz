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
    }
}
