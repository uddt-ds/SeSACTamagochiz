//
//  NameChangeViewController.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NameChangeViewController: UIViewController {

    var disposeBag = DisposeBag()

    let viewModel: NameChangeViewModel

    let textField: UITextField = {
        let txtField = UITextField()
        txtField.borderStyle = .none
        txtField.autocapitalizationType = .none
        txtField.autocorrectionType = .no
        return txtField
    }()

    let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.isUserInteractionEnabled = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        setupNav()
        bind()
    }

    init(viewModel: NameChangeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.textField.text = viewModel.nickname
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNav() {
        navigationItem.title = "대장님 이름 정하기"
        navigationItem.rightBarButtonItem = .init(customView: saveButton)
    }

    private func configureHierarchy() {
        [textField, underLine].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }

        underLine.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.directionalHorizontalEdges.equalTo(textField)
            make.height.equalTo(1)
        }
    }

    private func configureView() {
        view.backgroundColor = .white
    }

    private func bind() {

        let input = NameChangeViewModel.Input(nicknameText: textField.rx.text.orEmpty, saveButtonTapped: saveButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.validateError
            .bind(with: self) { owner, value in
                if !value.isEmpty {
                    owner.showAlert(message: value)
                }
            }
            .disposed(by: disposeBag)
//
        output.validateResult
            .bind(with: self) { owner, value in
                UserDefaults.standard.set(value, forKey: "nickname")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

}

extension NameChangeViewController {
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "경고", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
