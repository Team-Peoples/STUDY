//
//  FormViewModel.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit

// MARK: - FormViewModel

protocol FormViewModel {
    var formIsValid: Bool { get }
}

struct SignInViewModel: FormViewModel {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        let range = email?.range(of: "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$", options: .regularExpression)
        return email?.isEmpty == false && password?.isEmpty == false && range != nil
    }
}

struct StudyViewModel: FormViewModel {
    var study = Study(id: nil, title: nil, onoff: nil, category: nil, studyDescription: nil, isBlocked: nil, isPaused: nil, startDate: nil, endDate: nil)
    
    var formIsValid: Bool {
        
        return study.category != nil && study.title != nil && study.title != "" && study.onoff != nil && study.studyDescription != nil && study.studyDescription != ""
    }
}
