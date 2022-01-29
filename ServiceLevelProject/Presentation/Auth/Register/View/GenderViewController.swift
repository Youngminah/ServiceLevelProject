//
//  SetGenderViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit
import RxCocoa
import RxSwift
import Toast
import SnapKit

class GenderViewController: UIViewController {

    private let descriptionLabel = DefaultLabel(title: "성별을 선택해 주세요", font: .display1R20)
    private let detailLabel = DefaultLabel(title: "새싹 찾기 기능을 이용하기 위해서 필요해요!",
                                           font: .title2R16 ,
                                           textColor: .gray7)
    private let womanButton = GenderButton(gender: .woman)
    private let manButton = GenderButton(gender: .man)
    private let nextButton = DefaultButton(title: "다음")
    private lazy var stackView = UIStackView(arrangedSubviews: [manButton, womanButton])

    private lazy var input = GenderViewModel.Input(
        didManButtonTap: manButton.rx.tap.asSignal(),
        didWomanButtonTap: womanButton.rx.tap.asSignal(),
        didNextButtonTap: nextButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposdBag = DisposeBag()

    private var viewModel: GenderViewModel

    init(viewModel: GenderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("GenderViewController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
        bind()
    }

    private func bind() {
        output.isValid
            .drive(nextButton.rx.isValid)
            .disposed(by: disposdBag)

        output.isManSelected
            .drive(manButton.rx.isSelected)
            .disposed(by: disposdBag)

        output.isWomanSelected
            .drive(womanButton.rx.isSelected)
            .disposed(by: disposdBag)

        output.showToastAction
            .emit(onNext: { [unowned self] text in
                self.view.makeToast(text, position: .top)
            })
            .disposed(by: disposdBag)

        output.indicatorAction
            .drive(onNext: {
                $0 ? IndicatorView.shared.show(backgoundColor: Asset.transparent.color) : IndicatorView.shared.hide()
            })
            .disposed(by: disposdBag)
    }

    private func setViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(detailLabel)
        view.addSubview(stackView)
        view.addSubview(nextButton)
    }

    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(120)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
        stackView.spacing = 8
        womanButton.isSelected = true
    }
}
