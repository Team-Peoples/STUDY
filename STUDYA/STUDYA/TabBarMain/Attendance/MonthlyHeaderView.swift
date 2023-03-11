//
//  MonthlyHeaderView.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/03/12.
//

import UIKit

final class MonthlyHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    private let monthLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 12, isBold: true)
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(monthLabel)
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(35)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureCell(with month: String) {
        monthLabel.text = month + "월"
    }
}

