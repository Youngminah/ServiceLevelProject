//
//  UIView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/04.
//

import UIKit.UIView

extension UIView {

    func addShadow(radius: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = .zero
        //self.layer.masksToBounds = false
    }
}
