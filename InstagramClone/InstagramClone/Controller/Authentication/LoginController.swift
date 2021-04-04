//
//  LoginController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

final class LoginController: UIViewController {
    
    // - MARK: Properties
    private let iconImage: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(named: "Instagram_logo_white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField: UITextField = .init()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.keyboardType = .emailAddress
        textField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.7)])
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField: UITextField = .init()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.keyboardType = .emailAddress
        textField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.7)])
        textField.isSecureTextEntry = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button: UIButton = .init(type: .system)
        let attr: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(white: 1, alpha: 0.7), .font : UIFont.systemFont(ofSize: 16)]
        let boldAttr: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(white: 1, alpha: 0.7), .font : UIFont.boldSystemFont(ofSize: 16)]
        let attributedTitle: NSMutableAttributedString = .init(string: "Forgot your password? ", attributes: attr)
        attributedTitle.append(NSAttributedString(string: "Get help signing in.", attributes: boldAttr))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
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
        let attr: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(white: 1, alpha: 0.7), .font : UIFont.systemFont(ofSize: 16)]
        let boldAttr: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(white: 1, alpha: 0.7), .font : UIFont.boldSystemFont(ofSize: 16)]
        let attributedTitle: NSMutableAttributedString = .init(string: "Don't have an account?  ", attributes: attr)
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: boldAttr))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // - MARK: Helpers
    private func configureUI() {
        self.view.backgroundColor = .systemPink
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black   // 네비게이션바에 light tint를 적용한다.
        
        let gredient: CAGradientLayer = .init()
        gredient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gredient.locations = [0, 1]     // 처음부터 끝까지
        
        self.view.layer.addSublayer(gredient)
        gredient.frame = self.view.frame
        
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
}
