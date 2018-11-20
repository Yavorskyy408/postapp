//
//  DesignableImage.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 222//18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit

@IBDesignable class DesignableImage: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
