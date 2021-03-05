//
//  CustomKit.swift
//  StockApp
//
//  Created by Lanex-Mark on 3/3/21.
//

import Foundation
import UIKit

@IBDesignable
class CustomShapeView: UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: CGColor {
        set {
            layer.borderColor = newValue
        }
        get {
            return layer.borderColor!
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{
        get {
            return layer.shadowOffset
        }
        set {
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity : Float {
        get{
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}

@IBDesignable
class CustomButtonShape: UIButton {
    var originalFrame: CGRect!
    var originalCornerRad: CGFloat!
    var originalTitle: String!
    
    func animateButtonLoading(_ load: Bool) {
        self.originalFrame = self.frame
        self.originalCornerRad = self.layer.cornerRadius
        self.originalTitle = self.title(for: .normal)
        // if should animate
        if load {
            let spinner = UIActivityIndicatorView(frame: .zero)
            spinner.frame = CGRect(x: 0, y: 0, width: self.frame.height - 5, height: self.frame.height - 5)
            spinner.style = .large
            spinner.color = .white
            spinner.alpha = 1.0
            spinner.hidesWhenStopped = true
            spinner.tag = 11 /// must be unique for identification purposes
            
            self.addSubview(spinner)
            self.setTitle("", for: .normal)
            
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                //self.layer.cornerRadius = self.frame.height / 2
                //self.frame = CGRect(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height)
                self.layoutIfNeeded()
            } completion: { (done) in
                if done == true {
                    spinner.startAnimating()
                    spinner.center = self.center //CGPoint(x: self.frame.width / 2 + 1, y: self.frame.width / 2 + 1)
                    spinner.fadeTo(alpha: 1.0, duration: 0.2)
                    self.layoutIfNeeded()
                }
            }
            
            self.isUserInteractionEnabled = false

        } else {
            self.isUserInteractionEnabled = true
            for subview in self.subviews {
                if subview.tag == 11 {
                    subview.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.2) {
                self.layer.cornerRadius = self.originalCornerRad
                self.frame = self.originalFrame
                self.setTitle(self.originalTitle, for: .normal)
                self.layoutIfNeeded()
            }
        }
        
    }
    
    let pulseLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.clear.cgColor
        shape.lineWidth = 10
        shape.fillColor = UIColor.systemGray.withAlphaComponent(0.2).cgColor
        shape.lineCap = .round
        return shape
    }()
    
    fileprivate func setupShapes() {
        setNeedsLayout()
        layoutIfNeeded()
        
        let circularPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10)
        pulseLayer.frame = self.bounds
        pulseLayer.path = circularPath.cgPath
        self.layer.addSublayer(pulseLayer)
    }
    
    func pulse(_ pulseColor: CGColor? = nil) {
        if pulseLayer.animation(forKey: "pulsing") == nil {
            setupShapes()
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = 1.15
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.autoreverses = true
            animation.repeatCount = .infinity
            if pulseColor != nil {
                pulseLayer.fillColor = pulseColor
            }
            pulseLayer.add(animation, forKey: "pulsing")
        } else {
            pulseLayer.removeAnimation(forKey: "pulsing")
            pulse()
        }
    }
    
    func stopPulse() {
        pulseLayer.removeAnimation(forKey: "pulsing")
        pulseLayer.removeFromSuperlayer()
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOffset : CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor : UIColor {
        get {
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity : Float {
        get{
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
}

@IBDesignable
class CustomImageViewShape: UIImageView {
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
}

class CustomLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    @IBInspectable
    var corner_Radius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var border_Width: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var border_Color: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
    }
    
    @IBInspectable
    var shadow_Radius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadow_Offset : CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadow_Color : UIColor {
        get {
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadow_Opacity : Float {
        get{
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}

class CustomTextView: UITextView {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func firstRect(for range: UITextRange) -> CGRect {
        let padding = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        return bounds.inset(by: padding)
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    @IBInspectable
    var corner_Radius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var border_Width: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var border_Color: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
    }
    
    @IBInspectable
    var shadow_Radius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadow_Offset : CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadow_Color : UIColor {
        get {
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadow_Opacity : Float {
        get{
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}

class CustomTextField: UITextField {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        return bounds.inset(by: padding)
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    @IBInspectable
    var corner_Radius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var border_Width: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var border_Color: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
    }
    
//    @IBInspectable
//    var placeholder_Color: UIColor {
//        set {
//            self.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "placeholderColor") ?? UIColor.systemGray4])
//        }
//        get {
//            return UIColor.systemGray4
//        }
//    }
    
    @IBInspectable
    var shadow_Radius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadow_Offset : CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadow_Color : UIColor {
        get {
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadow_Opacity : Float {
        get{
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}

@IBDesignable
public class GradientView: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
    
}

class DecimalMinusTextField: UITextField {
    var shouldShowNegativeSign: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.keyboardType = UIKeyboardType.numberPad
        
    }
    
    fileprivate func getAccessoryButtons() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.superview!.frame.size.width, height: 44))
        view.backgroundColor = UIColor(named: "KeyboardColor") // UIColor.systemGray5
        
        let minusButton = UIButton(type: UIButton.ButtonType.custom)
        let doneButton = UIButton(type: UIButton.ButtonType.custom)
        minusButton.setTitle("—", for: UIControl.State())
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        doneButton.setTitle("Done", for: UIControl.State())
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        
        let buttonWidth = view.frame.size.width/3
        minusButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 44);
        doneButton.frame = CGRect(x: view.frame.size.width - buttonWidth, y: 0, width: buttonWidth, height: 44)
        
        minusButton.addTarget(self, action: #selector(DecimalMinusTextField.minusTouchUpInside(_:)), for: UIControl.Event.touchUpInside)
        doneButton.addTarget(self, action: #selector(DecimalMinusTextField.doneTouchUpInside(_:)), for: UIControl.Event.touchUpInside)
        
        view.addSubview(minusButton)
        view.addSubview(doneButton)
        
        return view
    }
    
    @objc func minusTouchUpInside(_ sender: UIButton!) {
        
        let text = self.text!
        if(text.count > 0) {
            let index: String.Index = text.index(text.startIndex, offsetBy: 1)
            let firstChar = text[..<index]
            if firstChar == "-" {
                self.text = String(text[index...])
            } else {
                self.text = "-" + text
            }
        }
    }
    
    @objc func doneTouchUpInside(_ sender: UIButton!) {
        self.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard shouldShowNegativeSign else {return}
        self.inputAccessoryView = getAccessoryButtons()
    }
}
