//
//  StopWatch.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import Foundation

struct StopWatch {

    var totalSeconds: Int
    var minutes: Int { return (totalSeconds % 3600) / 60 }
    var seconds: Int { return totalSeconds % 60 }
}

extension StopWatch {

    var simpleTimeString: String {
        let minutesText = timeText(from: minutes)
        let secondsText = timeText(from: seconds)
        return "\(minutesText):\(secondsText)"
    }

    private func timeText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
}
