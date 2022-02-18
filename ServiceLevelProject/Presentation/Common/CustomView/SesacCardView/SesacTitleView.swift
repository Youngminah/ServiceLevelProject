//
//  SesacTitleStackVIew.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit
import SnapKit

enum SesacTitleCase: Int, CaseIterable {

    case goodManner, punctual, quickResponse, kind, handy, beneficial

    var title: String {
        switch self {
        case .goodManner:
            return "좋은 매너"
        case .punctual:
            return "정확한 시간 약속"
        case .quickResponse:
            return "빠른 응답"
        case .kind:
            return "친절한 성격"
        case .handy:
            return "능숙한 취미 성격"
        case .beneficial:
            return "유익한 시간"
        }
    }
}

final class SesacTitleView: UIView {

    let buttons: [SelectionButton] = {
        var buttons = [SelectionButton]()
        SesacTitleCase.allCases.forEach { value in
            let button = SelectionButton(title: value.title)
            buttons.append(button)
        }
        return buttons
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        for i in 0..<3 {
            let index = i * 2
            let horizantalStackView = UIStackView(
                arrangedSubviews: [buttons[index], buttons[index + 1]]
            )
            horizantalStackView.axis = .horizontal
            horizantalStackView.distribution = .fillEqually
            horizantalStackView.spacing = 8
            stackView.addArrangedSubview(horizantalStackView)
        }
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    func setSesacTitle(reputation: [Int]) {
        for index in 0..<SesacTitleCase.allCases.count {
            buttons[index].isSelected = (reputation[index] > 0)
        }
    }

    private func setConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
        }
    }
}
