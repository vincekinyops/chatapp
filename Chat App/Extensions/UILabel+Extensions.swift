//
//  UILabel+Extensions.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/4/21.
//

import UIKit

extension UILabel {
    
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
