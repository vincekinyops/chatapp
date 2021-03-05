//
//  UIView+Extensions.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import UIKit

extension UIView {
    
    
    /// add bottom border
    /// - Parameters:
    ///   - color: border color
    ///   - width: how thick is the border
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func makeRightTriangle() {
        let target = self
        
        let path = CGMutablePath()
        let size = target.frame.size
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: (size.height / 2)))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor(named: "loginColor")?.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
    }
    
    func makeLeftTriangle() {
        let target = self
        
        let path = CGMutablePath()
        let size = target.frame.size
        
        path.move(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: (size.height / 2)))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: size.width, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor(named: "loginColor")?.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
    }
    
    func fadeTo(alpha: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
}
