//
//  UploadPostController.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/02.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

final class UploadPostController: UIViewController {
    // MARK: - Properties
    weak var delegate: UploadPostControllerDelegate?
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    private let photoImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var captionTextView: InputTextView = {
        let textView: InputTextView = .init()
        textView.delegate = self
        textView.placeholderText = "Enter caption.."
        textView.font = .systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "0/100"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    // MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))

        self.view.addSubview(photoImageView)
        self.view.addSubview(captionTextView)
        self.view.addSubview(characterCountLabel)
        
        photoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        photoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        photoImageView.layer.cornerRadius = 10
        
        captionTextView.topAnchor.constraint(equalTo: self.photoImageView.bottomAnchor, constant: 16).isActive = true
        captionTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        captionTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 12).isActive = true
        captionTextView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        characterCountLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        characterCountLabel.bottomAnchor.constraint(equalTo: self.captionTextView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func checkMaxLength(_ textView: UITextView) {
        if textView.text.count > 100 {
            textView.deleteBackward()
        }
    }
    
    // MARK: - Actions
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDone() {
        guard let image = selectedImage, let caption = captionTextView.text else { return }
        
        PostService.uploadPost(caption: caption, image: image) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
}

// MARK: - UITextViewDelegate
extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        
        let count: Int = textView.text.count
        characterCountLabel.text = "\(count)/100"
        
        //captionTextView.placeholderLabel.isHidden = !captionTextView.text.isEmpty
    }
}
