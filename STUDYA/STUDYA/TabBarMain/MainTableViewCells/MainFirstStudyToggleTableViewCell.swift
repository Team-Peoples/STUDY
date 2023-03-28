//
//  MainFirstStudyToggleTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/10/14.
//

import UIKit

class MainFirstStudyToggleTableViewCell: UITableViewCell {
    
    static let identifier = "MainFirstStudyToggleTableViewCell"
    
    private var studyTitle: String?
    
    internal var buttonTapped: () -> () = {}
    
    private lazy var dropdownButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        selectionStyle = .none

        configureDropdownButton()
        
        contentView.addSubview(dropdownButton)
        dropdownButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(10)
            make.centerY.equalTo(contentView)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureCellWithStudyTitle(studyTitle: String?) {
        guard let studyTitle = studyTitle else { return }
        dropdownButton.setTitle("\(studyTitle)  ", for: .normal)
    }
    
    private func configureDropdownButton() {
        dropdownButton.setTitleColor(UIColor.appColor(.ppsGray1), for: .normal)
        dropdownButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        dropdownButton.setImage(UIImage(named: "dropDown")?.withTintColor(UIColor.appColor(.ppsGray1), renderingMode: .alwaysOriginal), for: .normal)
        dropdownButton.setImage(UIImage(named: "dropUp")?.withTintColor(UIColor.appColor(.ppsGray1), renderingMode: .alwaysOriginal), for: .selected)
        dropdownButton.semanticContentAttribute = .forceRightToLeft
        dropdownButton.addTarget(self, action: #selector(dropdownButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func dropdownButtonDidTapped() {
        print(#function)
        buttonTapped()
    }
}
