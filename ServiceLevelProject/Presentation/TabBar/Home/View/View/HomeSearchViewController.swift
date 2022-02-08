//
//  HobbySetViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import SnapKit

final class HomeSearchViewController: UIViewController {

    private let searchBar = UISearchBar()
    let searchSesacButton = DefaultButton(title: "새싹 찾기")

    private let disposedBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindUI()
        setViews()
        setConstraints()
        setConfigurations()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }

    private func bind() {
    }

    private func bindUI() {
        RxKeyboard.instance.visibleHeight
            .drive(rx.keyboardHeightChanged)
        .disposed(by: disposedBag)
    }

    private func setViews() {
        navigationController?.navigationBar.topItem?.title = ""
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        view.addSubview(searchSesacButton)
    }

    private func setConstraints() {
        searchSesacButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchSesacButton.isValid = true
    }
}

// MARK: - keyboard
extension HomeSearchViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.searchBar.resignFirstResponder()
    }

    func raiseKeyboardWithButton(keyboardChangedHeight: CGFloat, button: DefaultButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.23, animations: {
                var bottomOffset = self.view.safeAreaInsets.bottom - keyboardChangedHeight
                var (offset, radius): (Int, CGFloat) = (0, 0)
                if keyboardChangedHeight == 0 {
                    (offset, radius) = (16, 8)
                    bottomOffset = -16
                }
                button.snp.updateConstraints { make in
                    make.right.equalToSuperview().offset(-offset)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomOffset)
                    make.left.equalToSuperview().offset(offset)
                }
                button.layer.cornerRadius = radius
                self.view.layoutIfNeeded()
            })
        }
    }
}
