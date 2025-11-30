//
//  KeyboardViewController.swift
//  KeyboardExtension
//
//  Created by Florence on 2025-11-22.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    enum ShiftState {
        case none
        case shift
        case caps
    }
    
    var rows: [UIStackView] = []
    
    var shiftState: ShiftState = .none
    var keysPage: Int = 1
    
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
        
        initRows()
        drawKeys()
    }
    
    func initRows() {
        for i in 0...Constants.keysPage1.count - 1 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = 6
            row.translatesAutoresizingMaskIntoConstraints = false
            
            rows.append(row)
            view.addSubview(row)
            
            var topAnchor: NSLayoutYAxisAnchor
            if (i == 0) {
                topAnchor = view.topAnchor
            } else {
                topAnchor = rows[i - 1].bottomAnchor
            }
            
            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                row.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                row.topAnchor.constraint(equalTo: topAnchor, constant: 15),
                row.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    }
    
    func drawKeys() {
        for row in 0...Constants.keysPage1.count - 1 {
            for view in rows[row].arrangedSubviews {
                view.removeFromSuperview()
            }
            for col in 0...Constants.keysPage1[row].count - 1 {
                let symbol = Constants.keysPage1[row][col]
                let button = createKey(title: symbol)
                rows[row].addArrangedSubview(button)
            }
        }
    }
    
    func createKey(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22)
        button.titleLabel?.textColor = .black
        
        button.backgroundColor = .white
        button.layer.setValue(title, forKey: "key")
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.shadowColor = UIColor.systemGray4.cgColor
        button.layer.shadowRadius = 1
        
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func keyPressed(_ sender: UIButton) {
        guard let key = sender.layer.value(forKey: "key") as? String else {return}
        
        switch key {
        case "⇧": shiftState = (shiftState == .none) ? .shift : .none
        default:
            if (shiftState == .shift) {
                shiftState = .none
            }
            textDocumentProxy.insertText(key)
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
