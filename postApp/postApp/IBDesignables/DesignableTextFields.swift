//
//  DesignableTextFields.swift
//  postApp
//
//  Created by Vasyl Yavorskyy on 12/04/2018.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit

@IBDesignable class DesignableTextFields: UITextField {
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var padding: CGFloat = 0
    let rightButtonWidth: CGFloat = 25
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2 - rightButtonWidth, height: bounds.height)
    }
    
    
}
//extension UITextField {
//    
//    func setBottomLine(borderColor: UIColor) {
//        
//        self.borderStyle = UITextBorderStyle.none
//        self.backgroundColor = UIColor.clear
//        
//        let borderLine = UIView()
//        let height = 1.0
//        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
//        
//        borderLine.backgroundColor = borderColor
//        self.addSubview(borderLine)
//    }
//}

