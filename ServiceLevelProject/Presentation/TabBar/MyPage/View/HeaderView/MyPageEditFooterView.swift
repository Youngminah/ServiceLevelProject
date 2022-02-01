//
//  MyPageEditFooterView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageEditFooterView: UITableViewHeaderFooterView {

    static let identifier = "MyPageEditFooterView."

    private let myGenderView = MyGenderView()
    private let myHobbyView = MyHobbyView()
    private let myPhoneNumberPermitView = MyPhoneNumberPermitView()
    private let ageRangeView = AgeRangeView()
    private let withdrawButton = DefaultButton(title: "회원탈퇴")

    lazy var withdrawButtonTap = withdrawButton.rx.tap.asSignal()
    let disposdBag = DisposeBag()

    private lazy var stackView = UIStackView(
        arrangedSubviews: [myGenderView,
                           myHobbyView,
                           myPhoneNumberPermitView,
                           ageRangeView,
                           withdrawButton]
    )

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setView()
        setConstraints()
        setConfigurations()
    }

    required init?(coder: NSCoder) {
        fatalError("MyPageMenuHeaderView: fatal error")
    }

    private func setView() {
        addSubview(stackView)
    }

    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
        myGenderView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        myHobbyView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        myPhoneNumberPermitView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        ageRangeView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        withdrawButton.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
    }

    private func setConfigurations() {
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        withdrawButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        withdrawButton.setTitleColor(.label, for: .normal)
        withdrawButton.titleLabel?.font = .title4R14
    }
}
