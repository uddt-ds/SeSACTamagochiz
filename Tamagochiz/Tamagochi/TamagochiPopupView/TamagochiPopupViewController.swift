//
//  TamagochiPopupViewController.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import UIKit
import RxSwift
import RxCocoa

final class TamagochiPopupViewController: UIViewController {

    var disposeBag = DisposeBag()

    var okButtonTapped: (() -> Void)?

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    // Reactive extension해서 buttonTap 이벤트 넣어주기
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ._1_1
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 4
        label.text = "테스트"
        label.backgroundColor = .white
        return label
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let greetLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "테스트"
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        return button
    }()

    private let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, okButton])
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillEqually
        stackView.spacing = -1
        return stackView
    }()

    var viewModel: TamagochiPopupViewModel

    init(viewModel: TamagochiPopupViewModel, okButtonTapped: (() -> Void)?) {
        self.okButtonTapped = okButtonTapped
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        initialConfigure()
        okButton.setTitle(viewModel.buttonTitle, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        bind()
    }

    private func configureHierarchy() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(containerView)
        [stackView, separatorLine, greetLabel, buttonStackView].forEach { containerView.addSubview($0) }
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(140)
        }

        label.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(90)
            make.height.equalTo(20)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }

        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(40)
        }

        greetLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(40)
        }

        [cancelButton, okButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }

        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(-4)
            make.bottom.equalTo(containerView.snp.bottom).inset(-4)
        }

        containerView.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.width.equalTo(300)
            make.center.equalToSuperview()
        }

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func initialConfigure() {
        label.text = viewModel.tamaData.name
        imageView.image = UIImage(named: viewModel.tamaData.image)
        greetLabel.text = viewModel.tamaData.tamaMessage
    }

    private func bind() {
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        okButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true) {
                    owner.okButtonTapped?()
                }
            }
            .disposed(by: disposeBag)
    }
}
