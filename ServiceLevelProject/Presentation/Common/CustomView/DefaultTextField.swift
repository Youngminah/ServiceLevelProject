//
//  AuthTextField.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/18.
//

import UIKit.UITextField

final class DefaultTextField: UITextField, UITextFieldDelegate {
    
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
        super.draw(rect)
        border.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.width, height: 1)
        setBorderLine()
    }
    
    required init?(coder: NSCoder) { 
        fatalError("AuthTextField: fatal Error")
    }
    
    private func setConfiguration() {
        delegate = self
        borderStyle = .none
        font = .title4R14
        addPadding()
    }
    
    private func addPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        leftView = paddingView
        leftViewMode = ViewMode.always
    }
    
    func setBorderLine() {
        border.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.width, height: 1)
        border.backgroundColor = UIColor.gray3.cgColor
        layer.addSublayer(border)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.backgroundColor = UIColor.black.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        border.backgroundColor = UIColor.gray3.cgColor
    }
}
