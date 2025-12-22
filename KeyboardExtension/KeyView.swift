//
//  KeyView.swift
//  CodingKeyboard
//
//  Created by Florence on 2025-12-21.
//

import UIKit

class KeyView: UIControl {

    let mainLabel = UILabel()
    let shiftLabel = UILabel()

    init(main: String, shift: String? = nil) {
        super.init(frame: .zero)

        layer.cornerRadius = 6
        backgroundColor = UIColor(white: 1.0, alpha: 1.0)

        mainLabel.text = main
        mainLabel.font = .systemFont(ofSize: 20)
        mainLabel.textAlignment = .center

        shiftLabel.text = shift
        shiftLabel.font = .systemFont(ofSize: 10)
        shiftLabel.textAlignment = .right
        shiftLabel.textColor = .secondaryLabel

        addSubview(mainLabel)
        addSubview(shiftLabel)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        shiftLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            shiftLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            shiftLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}
