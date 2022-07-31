//
//  Component.swift
//  Untitled-Study
//
//  Created by 서동운 on 2022/07/27.
//
import Foundation
import SnapKit

class customButton: UIButton {
    init(placeholder: String, isBold: Bool = true) {
        super.init(frame: .zero)
        
        layer.borderColor = UIColor.appColor(.purple).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 24
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        setTitle(placeholder, for: .normal)
        setTitleColor(UIColor.appColor(.purple), for: .normal)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill() {
        backgroundColor = UIColor.appColor(.purple)
        setTitleColor(.white, for: .normal)
    }
}

class grayBorderTextView: UITextView {
    
    init(placeholder: String, maxCharactersNumber: Int, height: Int = 50) {
        super.init(frame: .zero, textContainer: nil)
        
        autocorrectionType = .no
        autocapitalizationType = .none
        
        text = placeholder
        font = UIFont.systemFont(ofSize: 16)
        textColor = .systemGray3
        textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.cornerRadius = 10
        
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true

        let charactersNumberLabel: UILabel = {
            
            let label = UILabel(frame: .zero)
            
            label.text = "0/\(maxCharactersNumber)"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .systemGray3
            translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        self.addSubview(charactersNumberLabel)
        
        charactersNumberLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
            make.right.equalTo(self.safeAreaLayoutGuide).offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
