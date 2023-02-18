//
//  StudyHistoryTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/23.
//

import UIKit

final class StudyHistoryTableViewCell: UITableViewCell {
    
    internal var studyHistory: StudyHistory? {
        didSet {
            titleLabel.text = studyHistory?.name
            durationLabel.text = "\(studyHistory?.start ?? "")~\(studyHistory?.end ?? "")"
        }
    }
    
    private let titleLabel = CustomLabel(title: "스터디", tintColor: .ppsBlack, size: 16, isBold: true, isNecessaryTitle: false)
    private let durationLabel = CustomLabel(title: "", tintColor: .ppsGray1, size: 12)
    
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

struct StudyHistory {
    let name: String
    let start: String
    let end: String?
    let auth: String
    
    enum CodingKeys: String, CodingKey {
        case name, start, end
        case auth = "po"
    }
}
