//
//  MyCardHeaderView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/30.
//

import UIKit
import SnapKit

final class MyCardHeaderView: UITableViewHeaderFooterView {

    static let identifier = "MyCardHeaderView"

    private let profileView = SesacProfileView()
    private let cardView = SesacCardView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("MyPageMenuHeaderView: fatal error")
    }

    private func setView() {
        addSubview(profileView)
        addSubview(cardView)
        isUserInteractionEnabled = true
    }

    private func setConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(profileView.snp.width).multipliedBy(194.0 / 343)
        }
        cardView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16).priority(.low)
        }
    }
    
    func toggleAddTarget(target: Any?, action: Selector, event: UIControl.Event) {
        cardView.toggleAddTarget(target: target, action: action, event: event)
    }

    func setReviewText(text: String) {
        cardView.setReviewText(text: text)
    }

    func setToggleButtonImage(isToggle: Bool) {
        cardView.setToggleButtonImage(isToggle: isToggle)
    }
}
