//
//  ReportQuery.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/19.
//

import Foundation

struct ReportQueryDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "otheruid": otheruid,
            "reportedReputation": reportedReputation,
            "comment": comment
        ]
        return dict
    }

    let otheruid: String
    let reportedReputation: [Int]
    let comment: String

    init(report: ReportQuery) {
        otheruid = report.matchedUserID
        reportedReputation = report.report
        comment = report.text
    }
}
