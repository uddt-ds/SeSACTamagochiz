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
                //TODO: label을 가리는 판단 로직 ViewModel로 가야하는지 고민 필요
                if row == 0 {
                    cell.configureCell(with: element, isHidden: false)
                } else {
                    cell.configureCell(with: element, isHidden: true)
                }
                return cell
            }
            .disposed(by: disposeBag)

        Observable.zip(tableView.rx.modelSelected(TableViewDataModel.self), tableView.rx.itemSelected)
            .bind(with: self) { owner, result in
                switch result.1.row {
                case 0:
                    let viewModel = NameChangeViewModel(currentNickname: result.0.nickname)
                    let vc = NameChangeViewController(viewModel: viewModel)
                    owner.navigationItem.backButtonTitle = ""
                    owner.navigationController?.pushViewController(vc, animated: true)
                case 1:
                    let vc = TamagochiViewController()
                    owner.navigationItem.backButtonTitle = ""
                    owner.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    let alert = UIAlertController(title: "데이터 초기화", message: "정말 다시 처음부터 시작하실건가용?", preferredStyle: .alert)
                    let noAction = UIAlertAction(title: "아냐!", style: .default)
                    //TODO: 여기는 Rx에 맞게 확장하면 좋은 구조가 될거 같음
                    let okAction = UIAlertAction(title: "웅", style: .default) { _ in
                        owner.reset()
                        let vc = TamagochiViewController()
                        owner.navigationController?.setViewControllers([vc], animated: true)
                    }
                    alert.addAction(noAction)
                    alert.addAction(okAction)
                    owner.present(alert, animated: true)
                default:
                    return
                }
            }
            .disposed(by: disposeBag)
    }

    //TODO: 데이터 초기화하는 로직, 분기하는 로직과 병행해서 체크 필요
    private func reset() {
        UserDefaults.standard.set("대장", forKey: UserDefaultsKey.nickname.rawValue)
        UserDefaults.standard.set("", forKey: UserDefaultsKey.tamagochiName.rawValue)
        UserDefaults.standard.set(0, forKey: UserDefaultsKey.tamagochi.rawValue)
        UserDefaults.standard.set(0, forKey: UserDefaultsKey.level.rawValue)
        UserDefaults.standard.set(0, forKey: UserDefaultsKey.food.rawValue)
        UserDefaults.standard.set(0, forKey: UserDefaultsKey.water.rawValue)
    }
}
