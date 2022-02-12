//
//  CardCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/12.
//

import UIKit
import SnapKit

class CardCell: BaseTableViewCell {

    static let identifier = "CardCell"

    private let profileView = SesacProfileView()
    private let cardView = SesacCardView()
    var status: SearchSesacStatus = .near

    override func setView() {
        super.setView()
        addSubview(profileView)
        addSubview(cardView)
    }

    override func setConstraints() {
        super.setConstraints()
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

    override func setConfiguration() {
        super.setConfiguration()
    }

    func toggleAddTarget(target: Any?, action: Selector, event: UIControl.Event) {
        cardView.toggleAddTarget(target: target, action: action, event: event)
    }

    func setToggleButtonImage(isToggle: Bool) {
        cardView.setToggleButtonImage(isToggle: isToggle)
    }

    func updateUI(item: HobbySearchItemViewModel) {
        self.profileView.setBackgroundImage(image: item.background.image)
        self.profileView.setSesacImage(image: item.sesac.image)
        self.cardView.setSesacTitle(reputation: item.reputation)
        self.cardView.setNickname(nickname: item.nickname)
        if item.reviews.count != 0 {
            cardView.setReviewText(text: item.reviews[0])
        } else {
            cardView.setPlaceHolder()
        }
    }
}
