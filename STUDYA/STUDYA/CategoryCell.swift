//
//  CategoryCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/11.
//

import UIKit
import SnapKit

class RoundedPurpleCell: UICollectionViewCell {
    // MARK: - Properties
    
    let button = BrandButton(title: "", isBold: false, fontSize: 16, height: 28)
    var title: String? {
        didSet {
            guard let title = title else { return }
            button.setTitle(title, for: .normal)
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(button)
    }
    
    internal func configure(backgroundColor: AssetColor, normalTextColor: AssetColor, selectedTextColor: AssetColor) {
        button.backgroundColor = UIColor.appColor(backgroundColor)
        button.resetTitleColor(normal: normalTextColor, forSelected: selectedTextColor)
        button.layer.borderWidth = 0
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting Constraints
    
    func setConstraints(height: Int) {
        button.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.top.bottom.leading.trailing.equalTo(self)
        }
    }
}
final class CategoryCell: RoundedPurpleCell {
    
    var isSameTitle: Bool = false {
        didSet {
            isSameTitle ? categoryChanged() : nil
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.addTarget(nil, action: #selector(buttonDidTapped), for: .touchUpInside)
        
        configure(backgroundColor: .background, normalTextColor: .ppsGray1, selectedTextColor: .keyColor1)
        setConstraints(height: 28)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - Actions
    
    @objc private func buttonDidTapped() {
       categoryChanged()
    }
    
    func categoryChanged() {
        toogleButton()
        NotificationCenter.default.post(name: Notification.Name.categoryDidChange, object:  ["title": button.titleLabel?.text ?? ""])
    }
    
    func toogleButton() {
        button.isSelected.toggle()
        button.layer.borderWidth = button.isSelected ? 1 : 0
    }
}
