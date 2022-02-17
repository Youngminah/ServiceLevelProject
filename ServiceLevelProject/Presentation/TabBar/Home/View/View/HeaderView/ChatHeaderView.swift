//
//  ChatHeaderView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/15.
//

import UIKit
import SnapKit

final class ChatHeaderView: UITableViewHeaderFooterView {

    static let identifier = "ChatHeaderView."
    static let height: CGFloat = 100

    private let dateLabel = PaddingLabel()
    private let bellImageView = UIImageView(image: UIImage(named: "bell"))
    let topTitleLabel = DefaultLabel(font: .title3M14, textColor: .gray7)
    private let topMessageLabel = DefaultLabel(title: "채팅을 통해 약속을 정해보세요:)", font: .title4R14, textColor: .gray6)

    private lazy var topStackView = UIStackView(arrangedSubviews: [bellImageView, topTitleLabel])

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setView()
        setConstraints()
        setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("ChatHeaderView: fatal error")
    }

    private func setView() {
        addSubview(dateLabel)
        addSubview(topStackView)
        addSubview(topMessageLabel)
    }

    private func setConstraints() {
        bellImageView.snp.makeConstraints { make in
            make.height.width.equalTo(15)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(28)
        }
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        topMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(22)
        }
    }

    private func setConfiguration() {
        dateLabel.clipsToBounds = true
        dateLabel.layer.cornerRadius = 15
        dateLabel.backgroundColor = .gray7
        dateLabel.font = .title5M12
        dateLabel.textColor = .white
        topStackView.axis = .horizontal
        topStackView.clipsToBounds = true
        topStackView.alignment = .center
        topStackView.spacing = 3
        topMessageLabel.textAlignment = .center
        topTitleLabel.text = "..."
        dateLabel.text = "1월 15일 토요일"
    }
}
