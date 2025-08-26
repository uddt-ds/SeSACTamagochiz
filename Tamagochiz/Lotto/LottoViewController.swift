//
//  LottoViewController.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire

final class LottoViewController: UIViewController {

    var disposeBag = DisposeBag()

    let viewModel = LottoViewModel()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        return textField
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("버튼", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "테스트"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }

    private func configureView() {
        view.backgroundColor = .white

        [textField, button, resultLabel].forEach { view.addSubview($0) }

        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
        }

        button.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(20)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func bind() {

        let input = LottoViewModel.Input(buttonTap: button.rx.tap, textFieldText: textField.rx.text.orEmpty)

        let output = viewModel.transform(input: input)

        output.lottoResult
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)

        output.showAlert
            .bind(with: self) { owner, value in
                if value {
                    owner.view.makeToast("디코딩 실패", duration: 2, position: .bottom)
                }
            }
            .disposed(by: disposeBag)

//        resultLabel.rx.text

        // 2단계
//        button.rx.tap
//            .withLatestFrom(textField.rx.text.orEmpty)
//            .debug("textField 디버그")
//            .bind(with: self) { owner, value in
//                let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(value)"
//                AF.request(url)
//                    .responseDecodable(of: LottoModel.self) { responseData in
//                        switch responseData.result {
//                        case .success(let data):
//                            owner.lottoData.accept(data)
//                            owner.lottoData
//                                .debug("LottoModel 디버그")
//                                .map { $0.totalTitle }
//                                .bind(to: owner.resultLabel.rx.text)
//                                .disposed(by: owner.disposeBag)
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//            }
//            .disposed(by: disposeBag)

        // 1단계
//        textField.rx.text.orEmpty
//            .bind(with: self) { owenr, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
//
//        button.rx.tap
//            .bind(with: self) { owner, _ in
//                print("버튼이 눌렸습니다")
//            }
//            .disposed(by: disposeBag)

    }
}
