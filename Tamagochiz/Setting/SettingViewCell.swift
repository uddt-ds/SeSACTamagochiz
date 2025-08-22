//
//  SettingViewCel.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import UIKit
import SnapKit

final class SettingViewCell: UITableViewCell, ReusableViewProtocol {

    private let leftImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        return imageView
    }()

    private let menuLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftImageView, menuLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray3
        label.text = "테스트"
        label.isHidden = true
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.right")
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray4
        return button
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureHierarchy() {
        [leftStackView, subLabel, button].forEach { contentView.addSubview($0) }
    }

    private func configureLayout() {
        leftStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.directionalVerticalEdges.equalToSuperview().inset(12)
        }

        subLabel.snp.makeConstraints { make in
            make.trailing.equalTo(button.snp.leading).offset(-12)
            make.centerY.equalTo(button)
        }

        button.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }

    private func configureView() {
        contentView.backgroundColor = .clear
    }

    func configureCell(with data: TableViewDataModel, isHidden: Bool) {
        menuLabel.text = data.title
        leftImageView.image = UIImage(systemName: data.image)
        subLabel.isHidden = isHidden
    }
}
