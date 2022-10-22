//
//  ToDoItemTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/21.
//

import UIKit

class ToDoItemTableViewCell: UITableViewCell {
    
    static let identifier = "ToDoItemTableViewCell"
    internal var todo: String? {
        didSet {
            todoField.text = todo
        }
    }
    internal var isDone = false {
        didSet {
            checkButton.isSelected = isDone ? true : false
        }
    }
    internal var fieldDidEndEditingWithNoLetter: (ToDoItemTableViewCell) -> () = { sender in }
    internal var fieldDidEndEditingWithLetter: (ToDoItemTableViewCell) -> () = { sender in }
    
    lazy var checkButton: UIButton = {
        
        let b = UIButton(frame: .zero)
        
        b.setImage(UIImage(named: "off"), for: .normal)
        b.setImage(UIImage(named: "on"), for: .selected)
        b.isSelected = isDone ? true : false
        b.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        return b
    }()
    lazy var todoField: UITextField = {
       
        let f = UITextField()
        f.attributedPlaceholder = NSAttributedString(string: "이곳을 눌러 할 일을 추가해보세요.", attributes: [.foregroundColor: UIColor.appColor(.ppsGray1), .font: UIFont.systemFont(ofSize: 14)])
        return f
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .appColor(.background)
        todoField.font = .systemFont(ofSize: 14)
        todoField.delegate = self
        
        contentView.addSubview(checkButton)
        contentView.addSubview(todoField)
        
        checkButton.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor)
        todoField.anchor(top: contentView.topAnchor, leading: checkButton.trailingAnchor, leadingConstant: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
    }
}

extension ToDoItemTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if todoField.text == "" {
            fieldDidEndEditingWithNoLetter(self)
        } else {
            fieldDidEndEditingWithLetter(self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
