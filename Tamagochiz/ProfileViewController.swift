//
//  ProfileViewController.swift
//  Sesac7Week2Day1
//
//  Created by Lee on 7/8/25.
//

import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        designTextFieldUI()
        designBgView()
    }

    private func setNavigation() {
        self.navigationController?.navigationBar.topItem?.title = "설정"
        self.navigationItem.title = "대장님 이름 정하기"
        self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
    }

    private func designTextFieldUI() {
        nicknameTextField.backgroundColor = .clear
        nicknameTextField.textColor = .lightGray
        nicknameTextField.borderStyle = .none
        nicknameTextField.placeholder = "2글자 ~ 6글자의 이름을 설정해주세요"
    }

    private func designBgView() {
        bgView.backgroundColor = .black
    }

    private func checkTextField() {
        if let textField = nicknameTextField.text {
            if textField.count >= 2 && textField.count <= 6 {
                UserDefaultsManager.updateData { data in
                    data.nickname = textField
                }
                navigationController?.popViewController(animated: true)
            } else {
                showAlert(title: CustomError.wrongInput.title)
            }
        }
    }

    private func showAlert(title: String) {
        let alert = UIAlertController(title: "에러", message: title, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        checkTextField()
    }
    

    @IBAction func nicknameTextField(_ sender: UITextField) {
    }
}
