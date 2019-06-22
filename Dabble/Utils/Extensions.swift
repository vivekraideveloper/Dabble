//
//  Extensions.swift
//  Dabble
//
//  Created by Vivek Rai on 27/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


extension String {
    
    func subString( _ from: Int, length: Int ) -> String {
        
        let size = self.count
        
        let to = length + from
        if from < 0 || to > size {
            
            return ""
        }
        
        var result = ""
        
        for ( idx, char ) in self.enumerated() {
            
            if idx >= from && idx < to {
                
                result.append( char )
            }
        }
        
        return result
    }
    
    func removeWord( _ word:String ) -> String {
        
        var result = ""
        
        let textCharArr = Array( self)
        let wordCharArr = Array(word)
        
        var possibleMatch = ""
        
        var i = 0, j = 0
        while i < textCharArr.count {
            
            if textCharArr[ i ] == wordCharArr[ j ] {
                
                if j == wordCharArr.count - 1 {
                    
                    possibleMatch = ""
                    j = 0
                }
                else {
                    
                    possibleMatch.append( textCharArr[ i ] )
                    j += 1
                }
            }
            else {
                
                result.append( possibleMatch )
                possibleMatch = ""
                
                if j == 0 {
                    
                    result.append( textCharArr[ i ] )
                }
                else {
                    
                    j = 0
                    i -= 1
                }
            }
            
            i += 1
        }
        
        return result
    }
}


extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
        
    }
    func animHide(){
        
        UIView.animate(withDuration: 2, delay: 2, options: [.curveEaseOut], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = true
    }
}


import Foundation
import UIKit


extension UITextField {
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        endEditing(true)
    }
    
}

// MARK: - Gradient layer extensions
extension CAGradientLayer {
    
    func removeIfAdded() {
        if self.superlayer != nil {
            self.removeFromSuperlayer()
        }
    }
    
}

// MARK: - Shapelayer extenxions
extension CAShapeLayer {
    
    func setBorder(color: UIColor, borderWidth: CGFloat) {
        self.borderColor = color.cgColor
        self.borderWidth = borderWidth
    }
    
    func setShadow(color: UIColor, opacity: Float, offset: CGFloat, radius: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowOffset = CGSize(width: offset, height: offset)
        shadowRadius = radius
    }
    
    func removeIfAdded() {
        if self.superlayer != nil {
            self.removeFromSuperlayer()
        }
    }
    
}

extension UIView {
    
    func setShadow(color: UIColor, opacity: Float, offset: CGFloat, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: offset, height: offset)
        layer.shadowRadius = radius
    }
    
    func getGradientLayerOf(frame: CGRect, colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = CAGradientLayerType.axial
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        return gradientLayer
    }
    
    func removeIfAdded() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
    
}


extension Int {
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
}

extension BinaryInteger {
    public var toRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    public var toRadians: Self { return self * .pi / 180 }
    public var toDegree: Self { return self * 180 / .pi }
}
