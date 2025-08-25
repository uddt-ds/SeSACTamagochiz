//
//  BoxOfficeViewController.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import UIKit
import RxSwift
import RxCocoa

final class BoxOfficeViewController: UIViewController {

    var disposeBag = DisposeBag()

    let searchBar = UISearchBar()

    let items: [DailyBoxOfficeResult] = []

    let tableView: UITableView = {
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
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .flatMap { BoxOfficeCustomObservable.getBoxOfficeData(query: $0) }
            .bind(to: tableView.rx.items(cellIdentifier: BoxOfficeCell.identifier, cellType: BoxOfficeCell.self)) { (row, element, cell) in
                cell.configureCell(movieName: element.movieNm)
            }
            .disposed(by: disposeBag)
    }

}
