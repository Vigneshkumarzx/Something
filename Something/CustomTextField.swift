//
//  CustomTextField.swift
//  Something
//
//  Created by vignesh kumar c on 19/01/22.
//

import Foundation
import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {
    
    let border = CALayer()
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        createBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        createBorder()
    }
    func createBorder(){
        let width = CGFloat(1.5)
        border.borderColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height:self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}

