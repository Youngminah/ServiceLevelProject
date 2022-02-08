//
//  HobbySetViewController+Rx.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: HomeSearchViewController {

    var keyboardHeightChanged: Binder<CGFloat> {
        return Binder(base) { vc, height in
            vc.raiseKeyboardWithButton(keyboardChangedHeight: height, button: vc.searchSesacButton)
        }
    }
}
