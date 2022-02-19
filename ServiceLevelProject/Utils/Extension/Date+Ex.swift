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

    var toString: String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        let isToday = calendar.isDateInToday(self)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        if isToday {
            formatter.dateFormat = "a hh:mm"
        } else {
            formatter.dateFormat = "M/d a h:mm"
        }
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        return formatter.string(from: self)
    }
}
