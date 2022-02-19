//
//  SesacTitleButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectionButton: DefaultButton {

    override var isSelected: Bool {
        didSet {
            isSelected ? setValidStatus(status: .fill) : setValidStatus(status: .inactive)
        }
    }

    let selectedRelay = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        isSelected = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind() {
        let driver = rx.tap
            .map { [weak self] in
                guard let self = self else { return false }
                return !self.isSelected
            }
            .asDriver(onErrorJustReturn: false)

        driver
            .drive(rx.isSelected)
            .disposed(by: disposeBag)

        driver
            .drive(selectedRelay)
            .disposed(by: disposeBag)
    }

//    func setAddTarget() {
//        self.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
//    }
//
//    @objc
//    private func buttonTap() {
//        isSelected = !isSelected
//    }
}
