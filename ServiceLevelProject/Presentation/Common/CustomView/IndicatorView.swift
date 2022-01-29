//
//  IndicatorView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/27.
//

import UIKit
import SnapKit

final class IndicatorView: UIView {

    static let shared = IndicatorView()
    let viewForActivityIndicator = UIView()
    let activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        fatalError("IndicatorView: fatal Error Message")
    }

    func show(backgoundColor: UIColor) {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = backgoundColor
        DispatchQueue.main.async {[weak self] in
            self?.showIndicatorView()
        }
    }

    func hide() {
        DispatchQueue.main.async {[weak self] in
            self?.dismissIndicatorView()
        }
    }

    private func showIndicatorView() {
        self.viewForActivityIndicator.layer.cornerRadius = 10
        self.viewForActivityIndicator.backgroundColor = .gray1
        self.activityIndicator.style = .large
        self.activityIndicator.color = .green

        UIApplication.shared.windows.first?.addSubview(self)
        self.addSubview(self.viewForActivityIndicator)
        self.viewForActivityIndicator.addSubview(self.activityIndicator)

        self.viewForActivityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        self.activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        self.activityIndicator.startAnimating()
    }

    private func dismissIndicatorView() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        self.viewForActivityIndicator.removeFromSuperview()
        self.removeFromSuperview()
    }
}
