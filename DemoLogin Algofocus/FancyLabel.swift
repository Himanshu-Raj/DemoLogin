//
//  FancyLabel.swift
//  DemoLogin Algofocus
//
//  Created by Chaudhary Himanshu Raj on 03/01/18.
//  Copyright © 2018 Chaudhary Himanshu Raj. All rights reserved.
//

import UIKit

class FancyLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // This will give a grayish shadow tint to the view, to which this class will be assigned.
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }
    
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        _ = 1
        return bounds.insetBy(dx: 10, dy: 5)
    }
}
