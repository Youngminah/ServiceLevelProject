//
//  SetBirthViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit
import RxCocoa
import RxSwift
import Toast
import SnapKit

final class BirthViewController: UIViewController {

    private let descriptionLabel = DefaultLabel(title: "생년월일을 알려주세요", font: .display1R20)
    private let yearPickerTextField = DatePickerTextField(placeHolder: "1990")
    private let yearLabel = DefaultLabel(title: "년", font: .title2R16)
    private let monthPickerTextField = DatePickerTextField(placeHolder: "01")
    private let monthLabel = DefaultLabel(title: "월", font: .title2R16)
    private let dayPickerTextField = DatePickerTextField(placeHolder: "01")
    private let dayLabel = DefaultLabel(title: "일", font: .title2R16)
    private let nextButton = DefaultFillButton(title: "다음")
    private let datePicker = UIDatePicker()

    private lazy var stackView = UIStackView(arrangedSubviews: [
        yearPickerTextField,
        yearLabel,
        monthPickerTextField,
        monthLabel,
        dayPickerTextField,
        dayLabel
    ])

    private lazy var input = BirthViewModel.Input(
        didSelectedDatePicker: datePicker.rx.date.asSignal(onErrorJustReturn: Date()),
        didNextButtonTap: nextButton.rx.tap
            .map({ [unowned self] in
                return (
                    self.yearPickerTextField.text,
                    self.monthPickerTextField.text,
                    self.dayPickerTextField.text
                )
            })
            .asSignal(onErrorJustReturn: ("", "", ""))
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposdBag = DisposeBag()

    private var viewModel: BirthViewModel

    init(viewModel: BirthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BirthViewController: fatal error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
        bind()
    }

    private func bind() {
        output.showToastAction
            .emit(onNext: { [unowned self] text in
                self.view.makeToast(text, position: .top)
            })
            .disposed(by: disposdBag)

        output.isValid
            .drive(nextButton.rx.isValid)
            .disposed(by: disposdBag)

        output.yearText
            .emit(to: yearPickerTextField.rx.text)
            .disposed(by: disposdBag)

        output.monthText
            .emit(to: monthPickerTextField.rx.text)
            .disposed(by: disposdBag)

        output.dayText
            .emit(to: dayPickerTextField.rx.text)
            .disposed(by: disposdBag)
    }

    private func setViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(stackView)
        view.addSubview(nextButton)
    }

    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }

    private func setConfigurations() {
        title = ""
        view.backgroundColor = .white
        [yearPickerTextField, monthPickerTextField, dayPickerTextField].forEach {
            let doneButton = UIBarButtonItem(title: "Done",
                                             style: .plain,
                                             target: self,
                                             action: #selector(doneDatePickerTap))
            $0.setDatePickerToolbar(datePicker: datePicker, doneButton: doneButton)
        }
        [yearLabel, monthLabel, dayLabel].forEach { label in
            label.textAlignment = .right
        }
        stackView.spacing = 0
        stackView.distribution = .equalCentering
        yearPickerTextField.becomeFirstResponder()
    }

    @objc
    private func doneDatePickerTap() {
        self.view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
