//
//  InputTextView.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/02.
//

import UIKit

final class InputTextView: UITextView {
    // MARK: - properties
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    private let placeholderLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.addSubview(placeholderLabel)
        
        placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handleTextDidChange() {
        // 이걸 UploadPostController의 UITextViewDelegate 메서드에서 처리할 수도 있지만, placeholderLabel hidden 처리는
        // 앞으로도 계속 사용할 기능이고, 외부에서 placeholderLabel의 직접접근을 비허용하고자 이렇게 구현.
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}
