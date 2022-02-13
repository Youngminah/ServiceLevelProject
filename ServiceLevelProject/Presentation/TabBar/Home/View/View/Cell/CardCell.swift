//
//  CardCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/12.
//

import UIKit
import RxSwift
import SnapKit

class CardCell: BaseTableViewCell {

    static let identifier = "CardCell"

    private let profileView = SesacProfileView()
    let cardView = SesacCardView()
    let requestButton = DefaultButton(title: "요청하기")
    let receiveButton = DefaultButton(title: "수락하기")
    var isToggle = true
    var status: SearchSesacTab = .near

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setView() {
        super.setView()
        addSubview(profileView)
        addSubview(cardView)
        addSubview(requestButton)
        addSubview(receiveButton)
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
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.top).offset(12)
            make.right.equalTo(profileView.snp.right).offset(-12)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        receiveButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.top).offset(12)
            make.right.equalTo(profileView.snp.right).offset(-12)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        requestButton.backgroundColor = .error
        receiveButton.backgroundColor = .success
    }

    func didPressToggle() {
        isToggle = !isToggle
        cardView.setToggleButtonImage(isToggle: isToggle)
        if isToggle {
            cardView.snp.makeConstraints { make in
                make.top.equalTo(profileView.snp.bottom)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().offset(-16).priority(.low)
            }
        } else {
            cardView.snp.remakeConstraints { make in
                make.top.equalTo(profileView.snp.bottom)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.width.equalTo(80).priority(.low)
            }
        }
        print("didPressToggle")
        layoutIfNeeded()
    }

    func updateUI(item: HobbySearchItemViewModel, tabStatus: SearchSesacTab) {
        self.profileView.setBackgroundImage(image: item.background.image)
        self.profileView.setSesacImage(image: item.sesac.image)
        self.cardView.setSesacTitle(reputation: item.reputation)
        self.cardView.setNickname(nickname: item.nickname)
        if item.reviews.count != 0 {
            cardView.setReviewText(text: item.reviews[0])
        } else {
            cardView.setPlaceHolder()
        }
        self.setRequestButton(tabStatus: tabStatus)
    }

    private func setRequestButton(tabStatus: SearchSesacTab) {
        switch tabStatus {
        case .near:
            self.requestButton.isHidden = false
            self.receiveButton.isHidden = true
        case .receive:
            self.requestButton.isHidden = true
            self.receiveButton.isHidden = false
        }
    }
}
