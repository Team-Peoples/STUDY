//
//  StudyHistoryTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/23.
//

import UIKit

final class StudyHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "StudyHistoryTableViewCell"
    
    internal var studyHistory: ParticipatedStudyInfo? {
        didSet {
            titleLabel.text = studyHistory?.studyName
            let startDate = studyHistory?.createdAt ?? ""
            let endDate = studyHistory?.finishAt ?? ""
            let formattedStartDate = startDate.replacingOccurrences(of: #"(\d{4})-(\d{2})-(\d{2}).*"#, with: "$1.$2.$3", options: .regularExpression)
            let formattedEndDate = endDate.replacingOccurrences(of: #"(\d{4})-(\d{2})-(\d{2}).*"#, with: "$1.$2.$3", options: .regularExpression)
            durationLabel.text = "\(formattedStartDate)~\(formattedEndDate)"
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
