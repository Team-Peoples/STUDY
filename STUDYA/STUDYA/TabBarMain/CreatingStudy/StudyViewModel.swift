//
//  StudyViewModel.swift
//  STUDYA
//
//  Created by 서동운 on 3/6/23.
//

import Foundation

class StudyViewModel: ViewModel {
    typealias Model = Study
    
    var study: Study {
        didSet {
            handler?(study)
        }
    }
    
    var error: Observable<PeoplesError> = Observable(.noError)
    
    var handler: DataHandler?
    
    init(study: Study = Study()) {
        self.study = study
    }
    
    func bind(_ handler: DataHandler?) {
        self.handler = handler
        handler?(study)
    }
    
    func getStudyInfo(_ successHandler: @escaping (Study) -> Void) {
        guard let studyID = study.id else { return }
        
        Network.shared.getStudy(studyID: studyID) { [self] result in
            switch result {
            case .success(let studyOverall):
                study = studyOverall.study
                study.ownerNickname = studyOverall.ownerNickname
                successHandler(study)
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func postNewStudy(_ successHandler: @escaping (ID?) -> Void) {
        Network.shared.createStudy(study) { result in
            switch result {
            case .success(let study):
                successHandler(study.id)
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func updateStudy(successHandler: @escaping () -> Void) {
        guard let studyID = study.id else { return }
        
        Network.shared.updateStudy(study, id: studyID) { result in
            switch result {
            case .success:
               successHandler()
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func deleteStudy(successHandler: @escaping () -> Void) {
        guard let studyID = study.id else { return }
        
        Network.shared.closeStudy(studyID) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                self.error.value = error
            }
        }
    }
}
