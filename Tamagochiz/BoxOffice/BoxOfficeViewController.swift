//
//  BoxOfficeViewController.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class BoxOfficeViewController: UIViewController {

    private let viewModel = BoxOfficeViewModel()

    var disposeBag = DisposeBag()

    private let searchBar = UISearchBar()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .orange
        tableView.rowHeight = 120
        tableView.register(BoxOfficeCell.self, forCellReuseIdentifier: BoxOfficeCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
        makeGesture()
    }

    private func configureView() {
        [searchBar, tableView].forEach { view.addSubview($0) }

        searchBar.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bind() {

        let input = BoxOfficeViewModel.Input(searchButtonClicked: searchBar.rx.searchButtonClicked, searchBarText: searchBar.rx.text.orEmpty)

        let output = viewModel.transform(input: input)

        output.boxOfficeData
            .bind(to: tableView.rx.items(cellIdentifier: BoxOfficeCell.identifier, cellType: BoxOfficeCell.self)) { (row, element, cell) in
                cell.configureCell(movieName: element.movieNm)
            }
            .disposed(by: disposeBag)

        output.alertMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, errorMessage in
                owner.view.makeToast(errorMessage, duration: 2.0, position: .bottom)
            })
            .disposed(by: disposeBag)

        searchBar.rx.textDidEndEditing
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }

    private func makeGesture() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}
