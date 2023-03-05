//
//  AttendancePersonalViewController.swift
//  STUDYA
//
//  Created by 서동운 on 12/10/22.
//

import UIKit

class AttendancePersonalViewController: SwitchableViewController {
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = AttendanceForAMemberView(viewer: .manager)
        title = "스터디이름"
        navigationController?.setBrandNavigation()
    }
    
    // MARK: - Actions
    
    
    // MARK: - Configure
    
    private func configureViews() {
        
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
    }
}
