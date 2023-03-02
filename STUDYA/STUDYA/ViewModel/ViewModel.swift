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

// MARK: - SignInViewModel

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

// MARK: - StudyViewModel

// MARK: - StudyViewModel

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
                study.ownerNickname = studyOverall.ownerNickname
            case .failure(let failure):
                print(failure)
            }
        }
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
        
        Network.shared.closeStudy(studyID) { result in
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
    var deposit: Int {
        return generalRule.deposit
    }
    var excommunication: Excommunication {
        return generalRule.excommunication
    }
    
    init() {
        generalRule = GeneralStudyRule()
    }
    
    func configure(_ cell: CreatingStudyGeneralRuleAttendanceRuleCollectionViewCell) {
        cell.lateness = lateness
        cell.absence = absence
        cell.deposit = deposit
    }
    
    func configure(cell: CreatingStudyGeneralRuleExcommunicationRuleCollectionViewCell) {
        cell.lateNumberField.text = excommunication.lateness == nil ? "--" : String(excommunication.lateness!)
        cell.absenceNumberField.text = excommunication.absence == nil ? "--" : String(excommunication.absence!)
    }
}

// MARK: - StudyAllScheduleViewModel

class StudyScheduleViewModel: ViewModel {
    typealias Model = AllStudyScheduleOfAllStudy
    
    var allStudyScheduleOfAllStudy: AllStudyScheduleOfAllStudy {
        didSet {
            handler?(allStudyScheduleOfAllStudy)
        }
    }
    
    var handler: DataHandler?
    
    init(allStudyAllSchedule: AllStudyScheduleOfAllStudy = AllStudyScheduleOfAllStudy()) {
        self.allStudyScheduleOfAllStudy = allStudyAllSchedule
    }
    
    func bind(_ handler: DataHandler?) {
        self.handler = handler
        handler?(allStudyScheduleOfAllStudy)
    }
    
    func getAllStudyScheduleOfAllStudy() {
        Network.shared.getAllStudyScheduleOfAllStudy { result in
            switch result {
            case .success(let allStudyAllStudySchedule):
                self.allStudyScheduleOfAllStudy = allStudyAllStudySchedule
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteStudySchedule(id studyScheduleID: ID, deleteRepeatedSchedule: Bool, successHandler: @escaping () -> Void) {
        Network.shared.deleteStudySchedule(studyScheduleID, deleteRepeatSchedule: deleteRepeatedSchedule) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AllStudyScheduleOfAllStudy {
    // 스터디 ID를 포함한 스터디 스케쥴로 매핑
    func mappingStudyScheduleArray() -> [StudySchedule] {
        let mappedStudySchedule = self.flatMap { id, studySchedules in
            studySchedules.map {
                StudySchedule(studyName: $0.studyName, studyScheduleID: $0.studyScheduleID, studyID: id, topic: $0.topic, place: $0.place, startDateAndTime: $0.startDateAndTime, endDateAndTime: $0.endDateAndTime, repeatOption: $0.repeatOption)
            }
        }
        return mappedStudySchedule
    }
}

extension [StudySchedule] {
    func filteredStudySchedule(at date: Date) -> [StudySchedule]  {
        
        let filteredStudySchedule = self.filter { studySchedule in
            studySchedule.startDateAndTime.isSameDay(as: date)
        }
        return filteredStudySchedule
    }
    
    func filteredStudySchedule(by studyID: ID) -> [StudySchedule] {
        let filteredStudySchedule = self.filter { studySchedule in
            studySchedule.studyID == "\(studyID)"
        }
        return filteredStudySchedule
    }
}

// MARK: - StudyScheduleViewModel

class StudySchedulePostingViewModel: ViewModel {
    typealias Model = StudySchedulePosting
    
    var studySchedule: StudySchedulePosting {
        didSet {
            handler?(studySchedule)
        }
    }
    
    var handler: DataHandler?
    
    init(studySchedule: StudySchedulePosting = StudySchedulePosting()) {
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
    
    func updateStudySchedule(successHandler: @escaping () -> Void) {
        Network.shared.updateStudySchedule(studySchedule) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
}
