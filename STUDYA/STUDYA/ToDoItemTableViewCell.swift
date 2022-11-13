//
//  ToDoItemTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/21.
//

import UIKit

//🛑to be fixed: 이미 풀모달로 올라와있을 때는 올라오지 않게 할 수 있다면 setPosition 과 관련해서 기능추가해보기. 시스템 자원 절약 위해.
class ToDoItemTableViewCell: UITableViewCell {
    
    static let identifier = "ToDoItemTableViewCell"
    
    weak var cellDelegate: GrowingCellProtocol? //🛑weak 왜??
    weak var heightCoordinator: UBottomSheetCoordinator?
    
    internal var todo: String? {
        didSet {
            todoTextView.text = todo == nil ? placeholder : todo
            todoTextView.textColor = todo == nil ? UIColor.appColor(.ppsGray1) : .appColor(.ppsBlack)
        }
    }
    internal var isDone = false {
        didSet {
            checkButton.isSelected = isDone ? true : false
        }
    }
    internal var textViewDidEndEditingWithNoLetter: (ToDoItemTableViewCell) -> () = { sender in }
    internal var textViewDidEndEditingWithLetter: (ToDoItemTableViewCell) -> () = { sender in }
    private let placeholder = "이곳을 눌러 할 일을 추가해보세요."
    
    lazy var checkButton: UIButton = {
        
        let b = UIButton(frame: .zero)
        
        b.setImage(UIImage(named: "off"), for: .normal)
        b.setImage(UIImage(named: "on"), for: .selected)
        b.isSelected = isDone ? true : false
        b.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        return b
    }()
    lazy var todoTextView: UITextView = {
       
        let v = UITextView()
        
        v.font = .systemFont(ofSize: 15)
        v.text = placeholder
        v.textColor = .appColor(.ppsGray1)
        v.isScrollEnabled = false
        v.textContainer.maximumNumberOfLines = 3
        v.textContainer.lineBreakMode = .byTruncatingTail
        v.backgroundColor = .appColor(.background)
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.isScrollEnabled = false
        v.bounces = false
        
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .appColor(.background)
        todoTextView.font = .systemFont(ofSize: 14) //만약 더 큰 크기로 바꾸게 되면 글자수 제한이나 줄 수 등도 바꿔야.
        todoTextView.delegate = self
        
        contentView.addSubview(checkButton)
        contentView.addSubview(todoTextView)

        checkButton.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView)
            make.bottom.greaterThanOrEqualTo(contentView.snp.bottom).inset(65)
        }
        todoTextView.anchor(top: contentView.topAnchor, topConstant: -5.5, bottom: contentView.bottomAnchor, bottomConstant: 20, leading: checkButton.trailingAnchor, leadingConstant: 20, trailing: contentView.trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
        endEditing(true)
    }
}

extension ToDoItemTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            guard let inputedText = textView.text else { return true }
            let newLength = inputedText.count + text.count - range.length
            return newLength <= 70
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        heightCoordinator?.setPosition(UIScreen.main.bounds.height * 0.12, animated: true)
        
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .appColor(.ppsBlack)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .appColor(.ppsGray1)
            textViewDidEndEditingWithNoLetter(self)
        } else {
            textViewDidEndEditingWithLetter(self)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = cellDelegate {
            print(#function)
            delegate.updateHeightOfRow(self, textView)
        }
    }
}

protocol GrowingCellProtocol: AnyObject {
    func updateHeightOfRow(_ cell: ToDoItemTableViewCell, _ textView: UITextView)
}
