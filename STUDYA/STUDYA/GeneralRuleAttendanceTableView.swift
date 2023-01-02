//
//  GeneralRuleAttendanceTableView.swift
//  STUDYA
//
//  Created by 서동운 on 12/27/22.
//

import UIKit

class GeneralRuleAttendanceTableView: UITableView {
    
    // MARK: - Properties
    
    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    
        registerCells()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions
    
    // MARK: - Configure
    
    func configureViews() {
        
        backgroundColor = .appColor(.background)
        
        separatorStyle = .none
        alwaysBounceVertical = false
    }
    
    private func registerCells() {
        register(EditingStudyGeneralRuleAttendanceTimeTableViewCell.self, forCellReuseIdentifier: EditingStudyGeneralRuleAttendanceTimeTableViewCell.identifier)
        register(EditingStudyGeneralRuleAttendanceFineTableViewCell.self, forCellReuseIdentifier: EditingStudyGeneralRuleAttendanceFineTableViewCell.identifier)
        register(EditingStudyGeneralRuleDepositTableViewCell.self, forCellReuseIdentifier: EditingStudyGeneralRuleDepositTableViewCell.identifier)
    }
}
