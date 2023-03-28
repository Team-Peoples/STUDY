//
//  MonthlyFooterView.swift
//  STUDYA
//
//  Created by 신동훈 on 2023/03/12.
//

import UIKit

final class MonthlyFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    private let separatebar = UIView()
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(separatebar)
        
        separatebar.backgroundColor = .appColor(.ppsGray2)
        
        separatebar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(10)
            make.height.equalTo(1)
            make.centerY.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
