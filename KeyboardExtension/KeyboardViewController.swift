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
    
    var keyWidth: CGFloat = 0
    var extraMargin: CGFloat = 0
    var extraSpacing: CGFloat = 0
    var spaceBarWidth: CGFloat = 0
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if view.constraints.contains(where: { $0.identifier == "keyboardHeight" }) { return }
        
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: Dimens.KEYBOARD_HEIGHT)
        heightConstraint.identifier = "keyboardHeight"
        heightConstraint.isActive = true
//        view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
        
        initRows()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calculateDynamicDimens()
        drawKeys()
    }
    
    func calculateDynamicDimens() {
        print("calculateDynamicDimens()")
        let keysInRow = CGFloat(Keys.KEYS_1[0].count)
        let whiteSpaceWidth = (Dimens.EDGE_MARGIN * 2) + (Dimens.KEYS_SPACING * (keysInRow - 1))
        keyWidth = (view.bounds.width - whiteSpaceWidth) / keysInRow
        print(keyWidth)
        
        let keyWidthWithSpacing = keyWidth + Dimens.KEYS_SPACING
        extraMargin = keyWidthWithSpacing / 2
        print(extraMargin)
        
        let secondLastRowKeysWidth = (keyWidth * 7) + (Dimens.KEY_HEIGHT * 2)
        let secondLastRowWhiteSpaceWidth = (Dimens.EDGE_MARGIN * 2) + (Dimens.KEYS_SPACING * 8)
        extraSpacing = (view.bounds.width - secondLastRowKeysWidth - secondLastRowWhiteSpaceWidth) / 2
        print(extraSpacing)
        
        let lastRowKeysWidth = keyWidth * (needsInputModeSwitchKey ? 2 : 1) + Dimens.KEY_WIDE_WIDTH
        let lastRowWhiteSpaceWidth = (Dimens.EDGE_MARGIN * 2) + (Dimens.KEYS_SPACING * 3)
        spaceBarWidth = view.bounds.width - lastRowKeysWidth - lastRowWhiteSpaceWidth
        print(spaceBarWidth)
    }
 
    func initRows() {
        for i in 0...Keys.KEYS_1.count - 1 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fill
//            row.spacing = Dimens.KEYS_SPACING
            row.translatesAutoresizingMaskIntoConstraints = false
            
            rows.append(row)
            view.addSubview(row)
            
            var topAnchor: NSLayoutYAxisAnchor
            var topMargin: CGFloat
            if (i == 0) {
                topAnchor = view.topAnchor
                topMargin = Dimens.EDGE_MARGIN
            } else {
                topAnchor = rows[i - 1].bottomAnchor
                topMargin = Dimens.KEYS_TOP_MARGIN
            }
            
            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimens.EDGE_MARGIN),
                row.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimens.EDGE_MARGIN),
                row.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
                row.heightAnchor.constraint(equalToConstant: Dimens.KEY_HEIGHT)
            ])
        }
    }
    
    func drawKeys() {
        for row in 0...Keys.KEYS_1.count - 1 {
            removeAllSubViews(rows[row])
            if (row == 3) { rows[row].addArrangedSubview(spacer(extraMargin)) }
            for col in 0...Keys.KEYS_1[row].count - 1 {
                let symbol = Keys.KEYS_1[row][col]
                let button = createKey(title: symbol)
                rows[row].addArrangedSubview(button)
                
                if (col != Keys.KEYS_1[row].count - 1) {
                    rows[row].addArrangedSubview(spacer(Dimens.KEYS_SPACING))
                }
               
                if (symbol == "⇧" || symbol == "m") {
                    rows[row].addArrangedSubview(spacer(extraSpacing))
                }
            }
            if (row == 3) { rows[row].addArrangedSubview(spacer(extraMargin)) }
        }
    }
    
    func createKey(title: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let capsKey = title.capitalized
        let displayKey = shiftState == .none ? title : capsKey
        button.setTitle(displayKey, for: .normal)
        button.layer.setValue(displayKey, forKey: "key")
        
        button.titleLabel?.font = .systemFont(ofSize: Dimens.KEY_FONT_SIZE)
        button.setTitleColor(UIColor.label, for: .normal)
        button.backgroundColor = UIColor.systemBackground
        button.layer.cornerRadius = Dimens.KEY_CORNER_RADIUS
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if (Keys.SQUARE_KEYS.contains(title)) {
            button.widthAnchor.constraint(equalToConstant: Dimens.KEY_HEIGHT).isActive = true
        } else if (Keys.WIDE_KEYS.contains(title)) {
            button.widthAnchor.constraint(equalToConstant: Dimens.KEY_WIDE_WIDTH).isActive = true
        } else if (title == " ") {
            button.widthAnchor.constraint(equalToConstant: spaceBarWidth).isActive = true
        } else {
            button.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
        }
        
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        return button
    }
    
   
    func removeAllSubViews(_ stackView: UIStackView) {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    func spacer(_ width: CGFloat) -> UIView {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        return view
    }
    
    func unShiftAndInvalidate() {
        if (shiftState == .shift) {
            shiftState = .none
            drawKeys()
        }
    }
    
    @objc func keyPressed(_ sender: UIButton) {
        guard let key = sender.layer.value(forKey: "key") as? String else {return}
        
        switch key {
        case "⌫":
            unShiftAndInvalidate()
            textDocumentProxy.deleteBackward()
        case "→":
            textDocumentProxy.insertText("\t")
        case "return":
            textDocumentProxy.insertText("\n")
        case "⇧":
            shiftState = (shiftState == .none) ? .shift : .none
            drawKeys()
        default:
            unShiftAndInvalidate()
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
