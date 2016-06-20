//
//  customText.swift
//  HealthRunner
//
//  Created by sagaya Abdulhafeez on 20/06/2016.
//  Copyright © 2016 sagaya Abdulhafeez. All rights reserved.
//

import Foundation
import UIKit

class customText: UITextField {
    
    override func awakeFromNib() {
        
        layer.cornerRadius = 7.0
        layer.borderWidth  = 0.5
        let color: UIColor = UIColor.redColor()
        layer.borderColor = color.CGColor
        
    }
    
}