//
//  SearchBar+Rx.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/10.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {

    var searhBarTapWithText: Signal<String> {
        return searchButtonClicked
            .withLatestFrom(self.text.orEmpty)
            .asSignal(onErrorJustReturn: "")
    }
}
