//
//  TamagochiCell.swift
//  Tamagochiz
//
//  Created by Lee on 8/23/25.
//

import UIKit
import SnapKit

final class TamagochiCell: UICollectionViewCell, ReusableViewProtocol {

    // Reactive extension해서 buttonTap 이벤트 넣어주기
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ._1_1
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 51
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 4
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureHierarchy() {
        [stackView].forEach { contentView.addSubview($0) }
    }

    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(90)
            make.height.equalTo(16)
        }
    }

    private func configureView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    func configureCell(with data: TamagochiModel) {
        imageView.image = UIImage(named: data.image)
        label.text = data.name
    }
}
