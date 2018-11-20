//
//  DesignableView.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 212//18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear  {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 0.0 {
        didSet {
            // FIXME: max value must have 1
            self.layer.shadowOpacity = (Float(shadowOpacity / 10) >= 1) ? 1 : Float(shadowOpacity / 10)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0  {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0)  {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }


}
