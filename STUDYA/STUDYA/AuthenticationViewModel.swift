//
//  AuthenticationViewModel.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit

// MARK: - DoneButtonStateModel

protocol DoneButtonStateModel {
    func buttonStateUpdate()
}

// MARK: - AuthenticationViewModel

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}

// MARK: - InputFieldsModel

protocol InputFieldsModel {
    var textFieldsIsValid: Bool { get }
}

struct RuleViewModel {
    var generalStudyRule: GeneralStudyRule?
    var freeStudyRule: FreeStudyRule?
}

struct AttendanceRuleViewModel: InputFieldsModel {
    var attendanceRule: AttendanceRule?
    var textFieldsIsValid: Bool {
        return attendanceRule?.lateRuleTime != "--" || attendanceRule?.absenceRuleTime != "--"
    }
}
