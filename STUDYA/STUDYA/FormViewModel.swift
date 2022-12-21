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
    var study: Study
    var formIsValid: Bool {
        
        return study.category != nil && study.studyName != nil && study.studyName != "" && (study.studyOn != false || study.studyOff != false) && study.studyIntroduction != nil && study.studyIntroduction != ""
    }
    
    init(study: Study = Study(id: nil, isBlocked: nil, isPaused: nil)) {
        self.study = study
    }
}

