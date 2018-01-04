//
//  FancyBottomView.swift
//  DemoLogin Algofocus
//
//  Created by Chaudhary Himanshu Raj on 30/12/17.
//  Copyright © 2017 Chaudhary Himanshu Raj. All rights reserved.
//

import UIKit

class FancyBottomView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // This will give a grayish shadow tint to the view, to which this class will be assigned.
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
}
