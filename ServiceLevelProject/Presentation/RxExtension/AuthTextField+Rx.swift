//
//  AuthTextField+Rx.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/21.
//

import RxSwift

extension Reactive where Base: AuthTextField {

    var limitPhoneNumberText: Observable<String> {
        return text
            .orEmpty
            .filter { !$0.contains("-") }
            .map { text in
                return text.limitString(limitCount: 11)
            }
    }
}
