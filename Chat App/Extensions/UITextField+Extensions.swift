//
//  UITextField+Extensions.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import UIKit

extension UITextField {
    func setPlaceholderColor(_ text: String, _ color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
