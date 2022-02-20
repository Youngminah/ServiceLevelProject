//
//  SesacShopViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class SesacShopViewController: UIViewController {

    private let sesacView = SesacProfileView()
    private let sesacButton = TabButton(title: "새싹", isSelected: true)
    private let backgroundButton = TabButton(title: "배경")
    private let underBarView = UIView()
    private let slidingBarView = UIView()

    private let containerView = UIView()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        bind()
        setConstraints()
    }

    private func bind() {
        sesacButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.sesacButton.isSelected = true
                self.backgroundButton.isSelected = false
                self.underBarSlideAnimation(moveX: 0)
                self.changeViewToSesacView()
            })
            .disposed(by: disposeBag)

        backgroundButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.backgroundButton.isSelected = true
                self.sesacButton.isSelected = false
                self.underBarSlideAnimation(moveX: UIScreen.main.bounds.width / 2)
                self.changeViewToBackgroundView()
            })
            .disposed(by: disposeBag)
    }

    private func setViews() {
        view.addSubview(sesacView)
        view.addSubview(sesacButton)
        view.addSubview(backgroundButton)
        view.addSubview(underBarView)
        view.addSubview(containerView)
        underBarView.addSubview(slidingBarView)
    }

    private func setConstraints() {
        sesacView.snp.makeConstraints { make in
            make.left.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(175)
        }
        sesacButton.snp.makeConstraints { make in
            make.top.equalTo(sesacView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(45)
        }
        backgroundButton.snp.makeConstraints { make in
            make.top.equalTo(sesacView.snp.bottom)
            make.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(45)
        }
        underBarView.snp.makeConstraints { make in
            make.top.equalTo(sesacButton.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(2)
        }
        slidingBarView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(underBarView.snp.bottom)
            make.right.left.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setConfigurations() {
        underBarView.backgroundColor = .gray2
        slidingBarView.backgroundColor = .green
        changeViewToSesacView()
    }

    private func changeViewToSesacView() {
        for view in self.containerView.subviews {
            view.removeFromSuperview()
        }
        let vc = SesacViewController()
        vc.willMove(toParent: self)
        self.containerView.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addChild(vc)
        vc.didMove(toParent: self)
    }

    private func changeViewToBackgroundView() {
        for view in self.containerView.subviews {
            view.removeFromSuperview()
        }
        let vc = BackgroundViewController()
        vc.willMove(toParent: self)
        self.containerView.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addChild(vc)
        vc.didMove(toParent: self)
    }

    private func underBarSlideAnimation(moveX: CGFloat){
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8,initialSpringVelocity: 1, options: .allowUserInteraction, animations: { [weak self] in
            self?.slidingBarView.transform = CGAffineTransform(translationX: moveX, y: 0)
        }, completion: nil)
    }
}
