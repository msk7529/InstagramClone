//
//  LoginController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

final class LoginController: UIViewController {
    
    // - MARK: Properties
    private var viewModel: LoginViewModel = .init()
    
    private let iconImage: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(named: "Instagram_logo_white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
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
    
    private let loginButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.isEnabled = false
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let downHaveAccountButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObservers()
    }
    
    // - MARK: Helpers
    private func configureUI() {
        self.view.backgroundColor = .systemPink
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black   // 네비게이션바에 light tint를 적용한다.
        
        self.configureGradientLayer()
        
        self.view.addSubview(iconImage)
        self.view.addSubview(stackView)
        self.view.addSubview(downHaveAccountButton)
        
        iconImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        iconImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        stackView.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 32).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        
        downHaveAccountButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        downHaveAccountButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // - MARK: Actions
    @objc private func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to log user in \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleShowSignUp() {
        let registrationVC: RegistrationController = .init()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    @objc private func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        updateForm()
    }
}

// - MARK: FormViewModel
extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}
