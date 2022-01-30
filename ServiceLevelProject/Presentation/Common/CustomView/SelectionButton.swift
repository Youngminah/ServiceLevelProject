//
//  SesacTitleButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit

final class SelectionButton: DefaultButton {

    override var isSelected: Bool {
        didSet {
            isSelected ? setValidStatus(status: .fill) : setValidStatus(status: .inactive)
        }
    }

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        isSelected = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
