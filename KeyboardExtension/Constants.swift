//
//  Constants.swift
//  CodingKeyboard
//
//  Created by Florence on 2025-11-29.
//

import UIKit

class Keys {
    static let KEYS_1 = [
        [",", ".", "/", "\\", "-", "=", "[", "]", ";", "\'"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["⇧", "z", "x", "c", "v", "b", "n", "m", "⌫"],
        ["⇥", "🌐", " ", "return"]
    ]
    static let ICON_KEYS = ["⇧", "⌫", "⇥", "🌐"]
    static let WIDE_KEYS = ["return"]
}

class Dimens {
    static let KEY_HEIGHT: CGFloat = 50
    static let KEY_WIDE_WIDTH: CGFloat = 80
    static let KEY_CORNER_RADIUS: CGFloat = 8
    static let KEYS_TOP_MARGIN: CGFloat = 12
    static let KEYS_SPACING: CGFloat = 5
    static let EDGE_MARGIN: CGFloat = 5
    static let KEY_FONT_SIZE: CGFloat = 24
    static let KEYBOARD_HEIGHT: CGFloat = CGFloat(Keys.KEYS_1.count) * (KEY_HEIGHT + KEYS_TOP_MARGIN)
}
