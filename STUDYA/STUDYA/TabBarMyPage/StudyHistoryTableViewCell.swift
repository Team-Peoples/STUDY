//
//  StudyHistoryTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/23.
//

import UIKit

final class StudyHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "StudyHistoryTableViewCell"
    
    internal var studyIParticipatedIn: Study? {
        didSet(study) {
            titleLabel.text = study?.studyName
            durationLabel.text = "\(study?.createdAt ?? "")~\(study?.closedAt ?? "진행중")"
        }
    }
    
    private let titleLabel = CustomLabel(title: String(), tintColor: .ppsBlack, size: 16, isBold: true, isNecessaryTitle: false)
    private let durationLabel = CustomLabel(title: String(), tintColor: .ppsGray1, size: 12)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        addSubview(durationLabel)
        
        titleLabel.anchor(top: topAnchor, topConstant: 15, leading: leadingAnchor, leadingConstant: 20)
        durationLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 10, leading: titleLabel.leadingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
