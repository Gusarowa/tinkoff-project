//
//  ViewController.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 16.03.2023.
//

//import UIKit
//
//class ViewController: UIViewController {
//    private let emailTextField: UITextField = {
//           let textField = UITextField()
//           textField.placeholder = "Email"
//           textField.keyboardType = .emailAddress
//           textField.borderStyle = .roundedRect
//        textField.translatesAutoresizingMaskIntoConstraints = false
//           return textField
//       }()
//    private let passwordTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Password"
//        textField.isSecureTextEntry = true
//        textField.borderStyle = .roundedRect
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//    private let loginButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Log In", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = UIColor(cgColor: CGColor(red: 0.67, green: 0.88, blue: 0.69, alpha: 1))
//        button.layer.cornerRadius = 10
//        button.addTarget(ViewController.self, action: #selector(loginButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//        configureUI()
//    }
//
//    @objc private func loginButtonTapped() {
//        guard let email = emailTextField.text, !email.isEmpty,
//             let password = passwordTextField.text, !password.isEmpty else {
//            print("Please fill in all fields")
//            return
//        }
//    }
//
//    private func configureUI() {
//        let stackView = UIStackView(arrangedSubviews: [
//            emailTextField,
//            passwordTextField,
//            loginButton
//        ])
//        stackView.axis = .vertical
//        stackView.spacing = 16
//        view.addSubview(stackView)
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//        ])
//
//    }
//}
//
