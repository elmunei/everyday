//
//  CustomizableButton.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 6/3/17.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit

@IBDesignable class CustomizableButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 2 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
}
    
}
