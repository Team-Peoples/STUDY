//
//  ViewModel.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import Foundation

// MARK: - ViewModel

protocol ViewModel: AnyObject {
    associatedtype Model
    typealias DataHandler = (Model) -> Void

    var handler: DataHandler? { get set }
    
    func bind(_ handler: DataHandler?)
}

extension ViewModel {
   
    func bind(_ handler: DataHandler?) {
        self.handler = handler
    }
}

class SignInViewModel: ViewModel {
    
    typealias Model = Credential
    
    var credential: Credential {
        didSet {
            handler?(credential)
        }
    }
    var handler: DataHandler?
    
    init(credential: Credential = Credential()) {
        self.credential = credential
    }
    
    func singIn(_ successHandler: @escaping (User) -> Void, _ failureHandler: @escaping (PeoplesError) -> Void) {
        guard let email = credential.email, let password = credential.password else { return }
        
        Network.shared.signIn(id: email, pw: password) { result in
            switch result {
            case .success(let user):
                
                successHandler(user)
            case .failure(let error):
                
                failureHandler(error)
            }
        }
    }
}

class StudyViewModel: ViewModel {
    typealias Model = Study
    
    var study: Study {
        didSet {
            handler?(study)
        }
    }
    
    var handler: DataHandler?
    
    init(study: Study = Study()) {
        self.study = study
    }
    
    func bind(_ handler: DataHandler?) {
        self.handler = handler
        handler?(study)
    }
    
    func getStudyInfo() {
        
        guard let studyID = study.id else { return }
        
        Network.shared.getStudy(studyID: studyID) { [self] result in
            switch result {
            case .success(let studyOverall):
                study = studyOverall.study
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func postNewStudy(_ successHandler: @escaping () -> Void) {
        
        let study = study
        
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
        let study = study
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

class GeneralRuleViewModel {
    
    var generalRule: GeneralStudyRule
    var lateness: Lateness {
        return generalRule.lateness
    }
    var absence: Absence {
        return generalRule.absence
    }
    var deposit: Int? {
        return generalRule.deposit
    }
    var excommunication: Excommunication {
        return generalRule.excommunication
    }
    
    init() {
        generalRule = GeneralStudyRule()
    }
    
    func configure(_ cell: CreatingAttendanceRuleCollectionViewCell) {
        cell.lateness = lateness
        cell.absence = absence
        cell.deposit = deposit
    }
    
    func configure(cell: CreatingExcommunicationRuleCollectionViewCell) {
        cell.lateNumberField.text = excommunication.lateness == nil ? "--" : String(excommunication.lateness!)
        cell.absenceNumberField.text = excommunication.absence == nil ? "--" : String(excommunication.absence!)
    }
}

class StudyAllScheduleViewModel: ViewModel {
    typealias Model = StudyAllSchedule
    
    var studyAllSchedule: StudyAllSchedule {
        didSet {
            handler?(studyAllSchedule)
        }
    }
    
    var handler: DataHandler?
    
    init(studyAllSchedule: StudyAllSchedule = StudyAllSchedule()) {
        self.studyAllSchedule = studyAllSchedule
    }
    
    func bind(_ handler: DataHandler?) {
        self.handler = handler
        handler?(studyAllSchedule)
    }
    
    func getStudyAllSchedule(completion: (() -> Void)? = nil) {
        Network.shared.getStudyAllSchedule { result in
            switch result {
            case .success(let studyAllSchedule):
                self.studyAllSchedule = studyAllSchedule
                completion?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func studyScheduleDateComponents(of studyID: ID, completion: ([DateComponents]?) -> Void) {
        
        let dateComponents = studyAllSchedule["\(studyID)"]?.map { studySchedule in
            
            guard let dateComponents = studySchedule.startDate?.convertToDateComponents() else { fatalError() }
            return dateComponents
        }
//        print(dateComponents,"🔥")
        completion(dateComponents)
    }

    func studySchedules(of studyID: ID, at calendarSelectedDateComponents: DateComponents?) -> [StudySchedule]? {
        let studySchedules = studyAllSchedule["\(studyID)"]?.filter({ studySchedule in
            guard let dateComponents = studySchedule.startDate?.convertToDateComponents() else { fatalError() }
               let year = dateComponents.year
               let month = dateComponents.month
               let day = dateComponents.day

            return calendarSelectedDateComponents?.year == year && calendarSelectedDateComponents?.month == month && calendarSelectedDateComponents?.day == day
        })
        return studySchedules
    }
}

class StudyScheduleViewModel: ViewModel {
    
    typealias Model = StudyScheduleGoing
    
    var studySchedule: StudyScheduleGoing {
        didSet {
            handler?(studySchedule)
        }
    }
    
    var handler: DataHandler?
    
    init(studySchedule: StudyScheduleGoing = StudyScheduleGoing()) {
        self.studySchedule = studySchedule
    }
    
    func bind(_ handler: DataHandler?) {
        self.handler = handler
        handler?(studySchedule)
    }
    
    func postStudySchedule(successHandler: @escaping () -> Void) {
        Network.shared.createStudySchedule(studySchedule) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
}
