//
//  GeneralRuleAttendanceTableView.swift
//  STUDYA
//
//  Created by 서동운 on 12/27/22.
//

import UIKit

class GeneralRuleAttendanceTableView: UITableView {
    // MARK: - Properties
    
    lazy var toastMessage = ToastMessage(message: "먼저 지각 규칙을 입력해주세요.", messageColor: .whiteLabel, messageSize: 12, image: "alert")
    
    private var keyboardFrameHeight: CGFloat = 0
    
    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
//        addTapGestureRecognizers()
//
//        setDelegate()
//        setNotification()
        
        registerCells()
        configureViews()
        setConstaints()
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
//        addSubview(toastMessage)
    
    }
    
    private func registerCells() {
        register(EditingStudyGeneralRuleAttendanceTimeTableViewCell.self, forCellReuseIdentifier: EditingStudyGeneralRuleAttendanceTimeTableViewCell.identifier)
        register(EditingStudyGeneralRuleAttendanceFineTableViewCell.self, forCellReuseIdentifier: EditingStudyGeneralRuleAttendanceFineTableViewCell.identifier)
        register(EditingStudyGeneralRuleDepositTableViewCell.self, forCellReuseIdentifier: EditingStudyGeneralRuleDepositTableViewCell.identifier)
    }
    // MARK: - Setting Constraints
    
    func setConstaints() {
//        toastMessage.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
//            make.width.equalTo(view.frame.width - 14)
//            make.height.equalTo(42)
//            guard let bottomConstraintItem = bottomConstraintItem else { return }
//            make.bottom.equalTo(bottomConstraintItem).offset(-keyboardFrameHeight + 100)
//        }
    }
}
