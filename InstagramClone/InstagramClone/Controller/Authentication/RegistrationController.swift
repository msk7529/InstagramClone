//
//  RegistrationController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

final class RegistrationController: UIViewController {
    
    // - MARK: Properties
    private var viewModel: RegistrationViewModel = .init()
    
    private let plusPhotoButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emailTextField: CustomTextField = {
        let textField: CustomTextField = .init(placeholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField: CustomTextField = .init(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let fullnameTextField: CustomTextField = .init(placeholder: "Fullname")
    private let usernameTextField: CustomTextField = .init(placeholder: "Username")

    private let signUpButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.isEnabled = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureNotificationObservers()
    }
    
    // - MARK: Helpers
    private func configureUI() {
        self.view.backgroundColor = .systemPink
        navigationController?.navigationBar.isHidden = true     // true가 기본속성값
        navigationController?.navigationBar.barStyle = .black   // 네비게이션바에 light tint를 적용한다.
        
        self.configureGradientLayer()
        
        self.view.addSubview(plusPhotoButton)
        self.view.addSubview(stackView)
        self.view.addSubview(alreadyHaveAccountButton)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 32).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        
        alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // - MARK: Actions
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        updateForm()
    }
}

// - MARK: FormViewModel
extension RegistrationController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}
