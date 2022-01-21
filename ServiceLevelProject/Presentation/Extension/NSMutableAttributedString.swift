//
//  NSMutableAttributedString.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import UIKit

extension NSMutableAttributedString {

    func greenHighlight(string: String) -> NSMutableAttributedString {
        let font: UIFont = UIFont(name: SLPFont.medium.rawValue, size: 24)!
        let color: UIColor = .green
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }

    func regular(string: String) -> NSMutableAttributedString {
        let font: UIFont = UIFont(name: SLPFont.regular.rawValue, size: 24)!
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}
