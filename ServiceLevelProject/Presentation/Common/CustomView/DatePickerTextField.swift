//
//  DatePickerTextField.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/24.
//

import UIKit.UITextField

final class DatePickerTextField: UITextField {

    private let border = CALayer()

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        self.setConfiguration()
    }

    convenience init(placeHolder text: String) {
        self.init()
        placeholder = text
    }

    override func draw(_ rect: CGRect) {
        border.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.width, height: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("DatePickerTextField: fatal Error")
    }

    func setDatePickerToolbar(datePicker: UIDatePicker, doneButton: UIBarButtonItem) {
        let toolbar = UIToolbar()
        toolbar.barTintColor = .gray3
        toolbar.sizeToFit()
        toolbar.tintColor = .black

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                       target: nil,
                                       action: nil)

        toolbar.setItems([flexible, doneButton], animated: true)
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = defaultDate()
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        inputAccessoryView = toolbar
        inputView = datePicker
    }

    private func setConfiguration() {
        borderStyle = .none
        font = .title4R14
        setBorderLine()
    }

    private func setBorderLine() {
        border.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.width, height: 1)
        border.backgroundColor = UIColor.gray3.cgColor
        layer.addSublayer(border)
    }

    private func defaultDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.DD"
        let date = dateFormatter.date(from: "1990.01.01")!
        return date
    }
}
