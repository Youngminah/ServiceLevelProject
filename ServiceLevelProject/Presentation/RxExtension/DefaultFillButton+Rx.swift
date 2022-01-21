//
//  DefaultFillButton+Rx.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import RxSwift
import RxCocoa

extension Reactive where Base: DefaultFillButton {
    func isValid() -> Binder<Bool> {
        return Binder(base) { button, isValid in
            if isValid {
                button.isValid = true
            } else {
                button.isValid = false
            }
        }
    }
}
