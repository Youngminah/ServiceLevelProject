//
//  InputTextView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/18.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

extension Reactive where Base: InputTextView {

    var validText: Observable<String> {
        return text
            .orEmpty
            .filter { $0 != "" }
            .filter { $0 != "메세지를 입력하세요" }
    }
}
