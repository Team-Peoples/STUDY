//
//  MainDropDownTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/18.
//

import UIKit

class MainDropDownTableViewCell: UITableViewCell {

    static let identifier = "MainDropDownTableViewCell"
    
    internal var study: Study? {
        didSet {
            print(#function)
            titleLabel.text = study?.title
        }
    }
    internal var isCurrentStudy = false {
        didSet {
            if isCurrentStudy {
                contentView.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 249/255, alpha: 1)
            }
        }
    }
    
    private let titleLabel = CustomLabel(title: "요이", tintColor: .ppsBlack, size: 14, isBold: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(titleLabel)
        
        titleLabel.centerY(inView: contentView)
        titleLabel.anchor(leading: contentView.leadingAnchor, leadingConstant: 65)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.backgroundColor = .systemBackground
    }
}
