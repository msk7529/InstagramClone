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
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
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
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignUP), for: .touchUpInside)
        button.isEnabled = false
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
    @objc private func handleSignUP() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials: AuthCredentials = .init(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)

        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            print("DEBUG: Successfully registered user with firestore")
        }
    }
    
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleProfilePhotoSelect() {
        let picker: UIImagePickerController = .init()
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
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

// - MARK: UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2    // 적용안하면 버튼이 사각형으로 노출됨
        plusPhotoButton.layer.masksToBounds = true  // false이면 버튼 layer에 짤리지 않은 상태로 노출됨
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}
