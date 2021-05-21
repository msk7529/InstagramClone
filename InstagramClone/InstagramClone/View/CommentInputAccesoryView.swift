//
//  CommentInputAccesoryView.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/17.
//

import UIKit

protocol CommentInputAccesoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String)
}

final class CommentInputAccesoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    private let divider: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let commentTextView: InputTextView = {
        let textView: InputTextView = .init()
        textView.placeholderShouldCenter = true
        textView.placeholderText = "Enter comment.."
        textView.font = .systemFont(ofSize: 15)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let postButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        self.autoresizingMask = .flexibleHeight
        
        self.addSubview(divider)
        self.addSubview(commentTextView)
        self.addSubview(postButton)
        
        divider.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        divider.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        commentTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        commentTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        commentTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        
        postButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        postButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handlePostTapped() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text ?? "")
    }
    
    // MARK: - Helpers
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}
