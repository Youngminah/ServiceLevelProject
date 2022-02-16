//
//  String.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/16.
//

import Foundation

extension String {

    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        let date = dateFormatter.date(from: self)!
        return date
    }
}
