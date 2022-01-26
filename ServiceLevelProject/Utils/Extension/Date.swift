//
//  Date.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/26.
//

import Foundation

extension Date {

    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        return dateFormatter.string(from: self)
    }
}
