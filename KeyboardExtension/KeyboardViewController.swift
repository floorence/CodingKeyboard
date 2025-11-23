//
//  KeyboardViewController.swift
//  KeyboardExtension
//
//  Created by Florence on 2025-11-22.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    // TODO: investigate -[UIInputViewController needsInputModeSwitchKey] was called before a connection was established to the host application. This will produce an inaccurate result. Please make sure to call this after your primary view controller has been initialized.
    // happens when u switch to the keyboard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        view.backgroundColor = .systemGray
        
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 6
        
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.distribution = .fillEqually
        row2.spacing = 6
        
        let symbols = ["*","/","(",")","_","+","{","}",":","\""]
        let symbols2 = ["0","1","<",">","-","=","[","]",";","'"]
        
        for symbol in symbols {
            let button = createKey(title: symbol)
            row.addArrangedSubview(button)
        }
        
        for symbol in symbols2 {
            let button = createKey(title: symbol)
            row2.addArrangedSubview(button)
        }
        
        row.translatesAutoresizingMaskIntoConstraints = false
        row2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(row)
        view.addSubview(row2)
        
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            row.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            row.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            row.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            row2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            row2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            row2.topAnchor.constraint(equalTo: row.bottomAnchor, constant: 20),
            row2.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createKey(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.shadowColor = UIColor.systemGray4.cgColor
        button.layer.shadowRadius = 1
        
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func keyPressed(_ sender: UIButton) {
        if let text = sender.title(for: .normal) {
            textDocumentProxy.insertText(text)
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
   
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
