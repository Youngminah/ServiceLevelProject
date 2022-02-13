//
//  AlertView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/31.
//

import UIKit
import SnapKit

enum AlertStyle {
    case confirmAndCancel
    case confirm
}

final class AlertView: UIView {

    private let alertView: UIView = {
       let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 11
        return alert
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = .body1M16
        titleLabel.tintColor = .black
        return titleLabel
    }()

    private let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.font = .title4R14
        messageLabel.tintColor = .black
        return messageLabel
    }()

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .body3R14
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 11
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .body3R14
        button.backgroundColor = .gray2
        button.setTitleColor(.label, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 11
        return button
    }()

    private var title: String?
    private var message: String?
    private var completion: (() -> Void)?
    private var buttonStyle: AlertStyle = .confirm

    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(
        title: String,
        message: String? = nil,
        completion: (() -> Void)?
    ) {
        self.init(frame: CGRect.zero)
        self.title = title
        self.message = message
        self.completion = completion
    }

    convenience init(
        title: String,
        message: String? = nil,
        buttonStyle: AlertStyle,
        okCompletion: (() -> Void)?
    ) {
        self.init(frame: CGRect.zero)
        self.title = title
        self.message = message
        self.buttonStyle = buttonStyle
        self.completion = okCompletion
    }

    func showAlert() {
        self.setAttributes()
        self.setConstraints()
        self.setAnimation()
    }

    private func setAttributes() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        titleLabel.text = title
        messageLabel.text = message
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }

    @objc private func confirmAction() {
        completion?()
        removeAnimation()
    }

    @objc private func cancelAction() {
        removeAnimation()
    }

    private func setConstraints() {
        UIApplication.shared.windows.first?.addSubview(self)
        frame = UIScreen.main.bounds
        addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(alertView.snp.width).multipliedBy(156.0 / 344)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        buttonConstraint()
    }

    private func buttonConstraint() {
        switch buttonStyle {
        case .confirmAndCancel:
            alertView.addSubview(cancelButton)
            alertView.addSubview(confirmButton)
            cancelButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.bottom.equalToSuperview().offset(-16)
                make.width.equalToSuperview().offset(-20).dividedBy(2.0)
                make.height.equalTo(cancelButton.snp.width).multipliedBy(48 / 152.0)
            }
            confirmButton.snp.makeConstraints { make in
                make.right.bottom.equalToSuperview().offset(-16)
                make.width.equalToSuperview().offset(-20).dividedBy(2.0)
                make.height.equalTo(confirmButton.snp.width).multipliedBy(48 / 152.0)
            }
        case .confirm:
            alertView.addSubview(confirmButton)
            confirmButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.left.equalToSuperview().offset(16)
                make.right.bottom.equalToSuperview().offset(-16)
                make.height.equalTo(confirmButton.snp.width).multipliedBy(48 / 343.0)
            }
        }
    }

    private func setAnimation() {
        alertView.alpha = 0
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                self.alertView.alpha = 1
            })
        }
    }

    private func removeAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor = .clear
                self.alertView.alpha = 0
            }, completion: { _ in
                self.confirmButton.removeFromSuperview()
                self.messageLabel.removeFromSuperview()
                self.cancelButton.removeFromSuperview()
                self.titleLabel.removeFromSuperview()
                self.alertView.removeFromSuperview()
                self.removeFromSuperview()
            })
        }
    }
}
