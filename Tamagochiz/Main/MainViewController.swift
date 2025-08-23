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

    let viewModel = MainViewModel()

    var disposeBag = DisposeBag()

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

    var nickname: String = "대장"
    var level: Int = 1
    var foodCount: Int = 0
    var waterCount: Int = 0

    @BaseUserDefaults(key: UserDefaultKey.userData.rawValue,
                      defaultValue: UserModel(nickname: "대장", level: 0, foodCount: 0, waterCount: 0))
    var userData: UserModel

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        initialSetup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        designMainImageView()
        designBulloonImageView()
        designBulloonMessage()
        setupMonsterLabel()
        setupBgView()
        setupButtons()
        designTextFieldUI()
        designProfileButton()
        bind()
//        loadData()
//        updateState()
    }

    private func bind() {

        let viewDidLoadTrigger = Observable.just(())


        let input = MainViewModel.Input(viewDidLoadTrigger: viewDidLoadTrigger,
                                        feedTextField: foodTextField.rx.text.orEmpty,
                                        waterTextField: waterTextField.rx.text.orEmpty,
                                        feedButtonTapped: foodButton.rx.tap,
                                        waterButtonTapped: waterButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.feedCount
            .asDriver()
            .drive(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

        output.waterCount
            .asDriver()
            .drive(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

        output.userData
            .asDriver()
            .drive(with: self) { owner, data in
                print(data)
            }
            .disposed(by: disposeBag)

        output.totalResult
            .asDriver()
            .drive(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)

        output.tamagochiMessage
            .asDriver()
            .drive(textLabel.rx.text)
            .disposed(by: disposeBag)

        output.feedErrorMessage
            .asDriver()
            .drive(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

        output.waterErrorMessage
            .asDriver()
            .drive(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
    }

    // TODO: ImageView 변경하는 로직 -> 다마고치 Type에 따라서 다른 이미지로 변경해야 함 (다마고치 타입별 모델이 필요함)
    private func designMainImageView() {
        switch level {
        case 1: mainImageView.image = ._2_1
        case 2: mainImageView.image = ._2_2
        case 3: mainImageView.image = ._2_3
        case 4: mainImageView.image = ._2_4
        case 5: mainImageView.image = ._2_5
        case 6: mainImageView.image = ._2_6
        case 7: mainImageView.image = ._2_7
        case 8: mainImageView.image = ._2_8
        case 9: mainImageView.image = ._2_9
        case 10: mainImageView.image = ._2_9
        default: mainImageView.image = ._3_1
        }
        mainImageView.contentMode = .scaleAspectFit
    }

    private func designBulloonImageView() {
        bulloonImageView.image = .bubble
        bulloonImageView.contentMode = .scaleAspectFit
    }

//    // TODO: ViewModel에 있는 Message로 변경하여 재반영 예정
//    private func showBulloonMessage() {
//        let messageDb = [
//            #"\#(nickname)님,\#n복습 하셨나요?"#,
//            #"\#(nickname)님,\#n깃허브 푸시하셨나요?"#,
//            #"\#(nickname)님,\#n5시 칼퇴하실건가요?"#,
//            #"\#(nickname)님,\#n배고파요 밥주세요"#,
//            #"잘 챙겨주셔서 레벨업 했어요!\#n\#(nickname)님"#,
//            "밥 먹으니까 졸려요"
//        ]
//
//        messageLabel.text = messageDb.randomElement()
//    }

//    // TODO: ViewModel에 있는 UserData 가져와서 해당 닉네임으로 반영
//    private func setupNavigationBar() {
//        nickname = UserDefaults.standard.string(forKey: "nickname") ?? nickname
//        self.navigationItem.title = "\(nickname)님의 다마고치"
//    }

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

    // TODO: 다마고치 모델이 필요할 거 같음. 이름, 레벨별 이미지가 저장되어 있는 모델
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

    // TODO: ViewModel에서 넘겨준 데이터 사용하기
//    private func loadData() {
//        level = UserDefaults.standard.integer(forKey: "level")
//        foodCount = UserDefaults.standard.integer(forKey: "foodCount")
//        waterCount = UserDefaults.standard.integer(forKey: "waterCount")
//    }
//
//    // TODO: ViewModel에 데이터 넘겨줘서 ViewModel에서 UserDefault에 저장해야하는데 로직 고민 필요
//    private func saveData() {
//        UserDefaults.standard.set(level, forKey: "level")
//        UserDefaults.standard.set(foodCount, forKey: "foodCount")
//        UserDefaults.standard.set(waterCount, forKey: "waterCount")
//    }


//    // TODO: ViewModel에서 받아온 데이터를 토대로 반영
//    private func updateUI() {
//        designMainImageView()
//        textLabel.text = "LV\(level) • 밥알 \(foodCount)개 • 물방울 \(waterCount)개"
//        textLabel.textAlignment = .center
//    }
////
//    private func updateState() {
//        level = calculateLevel(foodCount: foodCount,
//                                   waterCount: waterCount)
//        updateUI()
////        saveData()
//    }

//    // TODO: 레벨 계산하는 로직 ViewModel로 넘어가야 함
//    private func calculateLevel(foodCount: Int, waterCount: Int) -> Int {
//        let result = ((foodCount / 5) + (waterCount / 2)) / 10
//
//        if result == 0 {
//            return 1
//        } else if result > 10 {
//            return 10
//        } else {
//            return result
//        }
//    }
//
//
//    // TODO: RxButtonTap으로 변경
//    @IBAction func buttonTapped(_ sender: UIButton) {
//
//        guard let buttonTitle = sender.currentTitle else {
//            return
//        }
//
//        let foodText = foodTextField.text ?? ""
//        let waterText = waterTextField.text ?? ""
//
//        if buttonTitle == ButtonTitle.food.title {
//            if foodText == "" {
//                foodCount += 1
//                updateState()
//            } else if Int(foodText) != nil {
//                if Int(foodText)! <= 100 {
//                    foodCount +=  Int(foodText)!
//                    print("foodCount: \( Int(foodText)! )")
//                    updateState()
//                } else {
//                    showAlert(title: CustomError.foodFull.title)
//                }
//            } else {
//                print(foodText)
//            }
//        } else if buttonTitle == ButtonTitle.water.title {
//            if waterText == "" {
//                waterCount += 1
//                updateState()
//            } else if Int(waterText) != nil {
//                if Int(waterText)! <= 50 {
//                    waterCount += Int(waterText)!
//                    print("foodCount: \( Int(waterText)! )")
//                    updateState()
//                } else {
//                    showAlert(title: CustomError.waterFull.title)
//                }
//            } else {
//                print(waterText)
//            }
//        }
//    }

    private func showAlert(title: String) {
        let alert = UIAlertController(title: "에러", message: title, preferredStyle: .alert)
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

