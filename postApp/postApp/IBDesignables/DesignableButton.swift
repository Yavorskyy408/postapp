//
//  DesignableButton.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 212//18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: BounceButton {

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
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            // FIXME: max value must have 1
            self.layer.shadowOpacity = (shadowOpacity / 10 >= 1) ? 1 : shadowOpacity / 10
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
            self.layer.masksToBounds = false
        }
    }
}
