//
//  CustomTextFieldInput.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 3/16/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit

class CustomTextFieldInput: UITextField {

    private var padding = UIEdgeInsets(top: 0, left: 35.0, bottom: 0, right: 0)

    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    func setupView() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        self.attributedPlaceholder = placeholder
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//Takes placeholder title
//Take UIImage
//Indents placeholder & text
}
