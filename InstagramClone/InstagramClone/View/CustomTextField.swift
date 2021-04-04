//
//  CustomTextField.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

final class CustomTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.borderStyle = .none
        self.textColor = .white
        self.keyboardAppearance = .dark
        self.backgroundColor = UIColor(white: 1, alpha: 0.1)
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.7)])
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.leftView = .init(frame: CGRect(x: 0, y: 0, width: 12, height: 50))
        self.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
