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

    private let titleLabel = DefaultLabel(title: "새싹 타이틀", font: .title4R14)

    private let buttons: [SesacTitleButton] = {
        var buttons = [SesacTitleButton]()
        SesacTitleCase.allCases.forEach { value in
            buttons.append(SesacTitleButton(title: value.title))
        }
        return buttons
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        for i in 0..<3 {
            let index = i * 2
            let horizantalStackView = UIStackView(
                arrangedSubviews: [buttons[index], buttons[index + 1]]
            )
            horizantalStackView.axis = .horizontal
            horizantalStackView.distribution = .fillEqually
            horizantalStackView.spacing = 3
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

    private func setConstraints() {
        addSubview(titleLabel)
        addSubview(stackView)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
}
