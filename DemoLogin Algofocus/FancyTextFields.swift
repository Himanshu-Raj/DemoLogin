//
//  FancyTextFields.swift
//  DemoLogin Algofocus
//
//  Created by Chaudhary Himanshu Raj on 30/12/17.
//  Copyright © 2017 Chaudhary Himanshu Raj. All rights reserved.
//

import UIKit

class FancyTextFields: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // This will give a grayish shadow tint to the view, to which this class will be assigned.
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
}
