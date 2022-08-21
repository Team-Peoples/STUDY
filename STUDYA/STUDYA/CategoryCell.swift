//
//  CategoryCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/11.
//

import UIKit
import SnapKit

extension Notification.Name {
    static let categoryDidChange = Notification.Name(rawValue: "categoryDidChange")
}


final class CategoryCell: UICollectionViewCell {
    // MARK: - Properties
    let button = CustomButton(title: "", isBold: false, size: 16, height: 28)
    var indexPath: IndexPath?
    var title: String? {
        didSet {
            guard let title = title else { return }
            button.setTitle(title, for: .normal)
        }
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        button.resetColorFor(normal: .subTitleGeneral, forSelected: .brandDark)
        button.layer.borderWidth = 0
        button.addTarget(nil, action: #selector(buttonDidTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        setConstraints(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - Actions
    
    @objc func buttonDidTapped() {
        button.isSelected.toggle()
        button.layer.borderWidth = button.isSelected ? 1 : 0
        if button.isSelected {
            NotificationCenter.default.post(name: Notification.Name.categoryDidChange, object:  ["title": button.titleLabel?.text ?? "", "indexPath": indexPath ?? IndexPath(row: 0, section: 0)])
        }
    }
    // MARK: - Setting Constraints
    
    func setConstraints(_ button: UIButton) {
        button.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.top.bottom.leading.trailing.equalTo(self)
        }
    }
}