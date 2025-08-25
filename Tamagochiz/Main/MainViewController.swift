//
//  ViewController.swift
//  Sesac7Week2Day1
//
//  Created by Lee on 7/7/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {

    var disposeBag = DisposeBag()

    let viewModel = MainViewModel()

    @IBOutlet var bulloonImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var foodTextField: UITextField!
    @IBOutlet var waterTextField: UITextField!
    @IBOutlet var backgroundView: UIView!

    @IBOutlet var monsterLabelBgView: UIView!
    @IBOutlet var monsterNameLabel: UILabel!

    @IBOutlet var foodTextFieldUnderLine: UIView!
    @IBOutlet var waterTextFieldUnderLine: UIView!

    @IBOutlet var foodButton: UIButton!
    @IBOutlet var waterButton: UIButton!

    @IBOutlet var profileButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        initialSetup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        designMainImageView()
        designBulloonImageView()
        designBulloonMessage()
        setupMonsterLabel()
        setupBgView()
        setupButtons()
        designTextFieldUI()
        designProfileButton()
        setupNavigationBar()
        bind()
//        updateState()
    }

    private func bind() {

        let viewDidLoadTrigger = Observable.just(())

        let input = MainViewModel.Input(viewDidLoadTrigger: viewDidLoadTrigger, foodTextField: foodTextField.rx.text.orEmpty, waterTextField: waterTextField.rx.text.orEmpty, foodButtonTapped: foodButton.rx.tap, waterButtonTapped: waterButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.foodErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                owner.showAlert(title: value)
            }
            .disposed(by: disposeBag)

        output.waterErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                owner.showAlert(title: value)
            }
            .disposed(by: disposeBag)

        output.totalResultLabel
            .asDriver()
            .drive(textLabel.rx.text)
            .disposed(by: disposeBag)

        output.tamagochiMessage
            .asDriver()
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)

        Observable.combineLatest(output.tamagochiRawValue, output.levelCount)
            .map { result in
                return TamaCategory(rawValue: result.0)?.getImage(with: result.1) ?? UIImage()
            }
            .asDriver(onErrorJustReturn: UIImage())
            .drive(mainImageView.rx.image)
            .disposed(by: disposeBag)

        output.tamagochiName
            .asDriver()
            .drive(monsterNameLabel.rx.text)
            .disposed(by: disposeBag)

        profileButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SettingViewController()
                owner.navigationItem.backButtonTitle = ""
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

    }

    private func designBulloonImageView() {
        bulloonImageView.image = .bubble
        bulloonImageView.contentMode = .scaleAspectFit
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "\(viewModel.nickname)님의 다마고치"
    }

    private func designBulloonMessage() {
        messageLabel.font = .systemFont(ofSize: 13)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
    }

//    private func initialSetup() {
//        setupNavigationBar()
//        showBulloonMessage()
//    }

    private func designProfileButton() {
        let image = UIImage(systemName: "person.circle")
        profileButton.setImage(image, for: .normal)
    }

    private func designMonsterLabelBgView() {
        monsterLabelBgView.backgroundColor = .systemGray6
        monsterLabelBgView.layer.cornerRadius = 10
        monsterLabelBgView.layer.borderWidth = 1.5
        monsterLabelBgView.layer.borderColor = UIColor.black.cgColor
    }

    private func designMonsterLabel() {
        monsterNameLabel.text = ""
        monsterNameLabel.textColor = .black
        monsterNameLabel.textAlignment = .center
        monsterNameLabel.font = .boldSystemFont(ofSize: 12)
    }

    private func setupMonsterLabel() {
        designMonsterLabelBgView()
        designMonsterLabel()
    }

    private func setupBgView() {
        backgroundView.backgroundColor = .clear
        foodTextFieldUnderLine.backgroundColor = .black
        waterTextFieldUnderLine.backgroundColor = .black
    }

    private func designButtonUI(_ button: UIButton,
                                image: UIImage,
                                title: String) {
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.tintColor = .systemGray
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
        button.backgroundColor = .clear
    }

    private func setupButtons() {
        designButtonUI(foodButton,
                       image: UIImage(systemName: AssetImage.food.title) ?? UIImage(),
                       title: ButtonTitle.food.title)
        designButtonUI(waterButton,
                       image: UIImage(systemName: AssetImage.water.title) ?? UIImage(),
                       title: ButtonTitle.water.title)
    }

    private func designTextFieldUI() {
        [foodTextField, waterTextField].forEach {
            $0?.backgroundColor = .clear
            $0?.borderStyle = .none
            $0?.keyboardType = .numberPad
        }
    }

    private func showAlert(title: String) {
        let alert = UIAlertController(title: "안돼요", message: title, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


extension MainViewController {
    enum AssetImage {
        case food
        case water

        var title: String {
            switch self {
            case .food: return "leaf.circle"
            case .water: return "drop.circle"
            }
        }
    }

    enum ButtonTitle {
        case food
        case water

        var title: String {
            switch self {
            case .food: return "밥먹기"
            case .water: return "물먹기"
            }
        }
    }
}
