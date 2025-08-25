//
//  BoxOfficeCell.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import UIKit
import SnapKit

class BoxOfficeCell: UITableViewCell {
    static let identifier = "Cell"

    let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureView() {
        [titleLabel].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(20)
        }
    }


    func configureCell(movieName: String) {
        titleLabel.text = movieName
    }
}

