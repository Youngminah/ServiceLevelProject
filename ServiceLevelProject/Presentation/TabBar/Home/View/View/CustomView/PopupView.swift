//
//  WriteReviewAlertView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/18.
//

import UIKit
import SnapKit

enum PopupStyle {
    case report
    case review
}

final class PopupView: UIView {

    private let contentView = UIView()
    private let dismissButton = UIButton()
    private let titleLabel = DefaultLabel(font: .title3M14, textColor: .black)
    private let messageLabel = DefaultLabel(font: .title4R14, textColor: .green)
    private let reviewSelectionView = SesacTitleView()
    private let reportSelectionView = SesacReportView()
    private let doneButton = DefaultButton()
    private let textView = UITextView()

    private var completion: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(
        style: PopupStyle,
        completion: (() -> Void)?
    ) {
        self.init(frame: CGRect.zero)
        self.setConfiguration(style: style)
        self.completion = completion
    }

    private func setConfiguration(style: PopupStyle) {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)

        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20

        textView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 44)
        textView.backgroundColor = .gray1
        textView.layer.cornerRadius = 8
        textView.font = .body3R14

        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = .gray6
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)

        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.isValid = false
        switch style {
        case .report:
            self.setReportConfiguration()
        case .review:
            self.setReviewConfiguration()
        }
    }

    @objc private func dismissAction() {
        removeAnimation()
    }

    @objc private func doneAction() {
        completion?()
        removeAnimation()
    }

    func showPopup(style: PopupStyle) {
        self.setViews(style: style)
        self.setAnimation()
    }

    private func setViews(style: PopupStyle) {
        UIApplication.shared.windows.first?.addSubview(self)
        frame = UIScreen.main.bounds
        addSubview(contentView)
        contentView.addSubview(dismissButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(doneButton)
        contentView.addSubview(textView)

        switch style {
        case .report:
            contentView.addSubview(reportSelectionView)
            contentView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(410)
            }
        case .review:
            contentView.addSubview(reviewSelectionView)
            contentView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(450)
            }
        }
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(28)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalTo(dismissButton.snp.left).offset(-16)
            make.height.equalTo(22)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(22)
        }
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(doneButton.snp.top).offset(-16)
            make.height.equalTo(130)
        }

        switch style {
        case .report:
            reportSelectionView.snp.makeConstraints { make in
                make.top.equalTo(messageLabel.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.bottom.equalTo(textView.snp.top).offset(-20)
            }
        case .review:
            reviewSelectionView.snp.makeConstraints { make in
                make.top.equalTo(messageLabel.snp.bottom).offset(16)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalTo(textView.snp.top).offset(-4)
            }
        }
    }

    private func setAnimation() {
        contentView.alpha = 0
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                self.contentView.alpha = 1
            })
        }
    }

    private func removeAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor = .clear
                self.contentView.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}

extension PopupView {

    private func setReportConfiguration() {
        titleLabel.text = "새싹 신고"
        messageLabel.text = "다시는 해당 새싹과 매칭되지 않습니다."
        doneButton.setTitle("신고하기", for: .normal)
    }
}

extension PopupView {

    private func setReviewConfiguration() {
        titleLabel.text = "리뷰 등록"
        messageLabel.text = "다시는 해당 새싹과 매칭되지 않습니다."
        reviewSelectionView.buttons.forEach { $0.setAddTarget() }
        doneButton.setTitle("리뷰 등록하기", for: .normal)
    }
}
