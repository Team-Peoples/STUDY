//
//  StudyHistoryTableViewCell.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/23.
//

import UIKit
import SwiftUI

final class StudyHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "StudyHistoryTableViewCell"
    internal var studyHistory: StudyHistory? {
        didSet {
            titleLabel.text = studyHistory?.name
            durationLabel.text = "\(studyHistory?.start ?? "")~\(studyHistory?.end ?? "")"
        }
    }
    
    private let titleLabel = CustomLabel(title: "스터디", tintColor: .titleGeneral, size: 16, isBold: true, isNecessaryTitle: false)
    private let durationLabel = CustomLabel(title: "", tintColor: .descriptionGeneral, size: 12)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        addSubview(durationLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        titleLabel.anchor(top: topAnchor, topConstant: 15, leading: leadingAnchor, leadingConstant: 20)
        durationLabel.anchor(top: titleLabel.bottomAnchor, topConstant: 10, leading: titleLabel.leadingAnchor)
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
