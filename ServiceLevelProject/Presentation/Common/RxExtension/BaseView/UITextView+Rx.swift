//
//  UITextView+Rx.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/19.
//

import UIKit.UITextView
import RxCocoa
import RxSwift

extension Reactive where Base: UITextView {

    var isText: Observable<Bool> {
        return text
            .orEmpty
            .map {
                return $0 != "" && base.textColor != .gray7
            }
    }
}
