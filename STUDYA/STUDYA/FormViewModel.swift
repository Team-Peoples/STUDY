//
//  FormViewModel.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import Foundation

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
    var study: Study {
        didSet {
            print("스터디 업데이트","🔥")
            handler?(study)
        }
    }
    
    typealias StudyDataHandler = (Study) -> Void
    var handler: StudyDataHandler?
    
    var formIsValid: Bool {
        
        return study.category != nil && study.studyName != nil && study.studyName != "" && (study.studyOn != false || study.studyOff != false) && study.studyIntroduction != nil && study.studyIntroduction != ""
    }
    
    init(study: Study = Study(id: nil, isBlocked: nil, isPaused: nil)) {
        self.study = study
    }
    
    init() {
        study = Study(id: nil, isBlocked: nil, isPaused: nil)
    }
    
    mutating func bind(_ handler: StudyDataHandler?) {
        self.handler = handler
        handler?(study)
    }
    
    func postNewStudy(_ successHandler: @escaping () -> Void) {
        
        Network.shared.createStudy(study) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateStudy(successHandler: @escaping () -> Void) {
        guard let studyID = study.id else { return }
        
        Network.shared.updateStudy(study, id: studyID) { result in
            switch result {
            case .success:
               successHandler()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func deleteStudy(successHandler: @escaping () -> Void) {
        guard let studyID = study.id else { return }
        
        Network.shared.deleteStudy(studyID) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
}

