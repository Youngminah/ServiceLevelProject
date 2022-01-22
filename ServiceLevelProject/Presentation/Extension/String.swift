//
//  String.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import Foundation

extension String {

    func limitString(limitCount: Int) -> String {  // 1000 넘으면 입력안됨.
        if self.count > limitCount {
            let index = self.index(self.startIndex, offsetBy: limitCount)
            return String( self[..<index] )
        }
        return self
    }

    func removeHipon() -> String {
        return self.components(separatedBy: ["-"]).joined()
    }

    func addHipon() -> String {
        let target = self.removeHipon()
        if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
            let modString = regex.stringByReplacingMatches(in: target, options: [], range: NSRange(target.startIndex..., in: target), withTemplate: "$1-$2-$3")
            return modString
        }
        return self
    }

    func isValidPhoneNumber() -> Bool {
        let regex = "^01[0-1, 7][0-9]{7,8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid ? true : false
    }

    func isValidCertificationNumber() -> Bool {
        let regex = "[0-9]{0,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid ? true : false
    }
}
