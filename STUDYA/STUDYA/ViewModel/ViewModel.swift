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

class StudyAllScheduleViewModel: ViewModel {
    typealias Model = [StudyScheduleComing]
    
    var allStudyAllSchedule: AllStudyAllSchedule {
        didSet {
            var studyScheduleList = [StudyScheduleComing]()
            
            allStudyAllSchedule.forEach { (studyID, studySchedules) in
                studySchedules.forEach({ studySchedule in
                    var studySchedule = studySchedule
                    studySchedule.studyID = studyID
                    
                    studyScheduleList.append(studySchedule)
                })
            }
            studySchedules = studyScheduleList
        }
    }
    
    var studySchedules: [StudyScheduleComing] = [] {
        didSet {
            handler?(studySchedules)
        }
    }
    
    var handler: DataHandler?
    
    init(allStudyAllSchedule: AllStudyAllSchedule = AllStudyAllSchedule()) {
        self.allStudyAllSchedule = allStudyAllSchedule
    }
    
    func bind(_ handler: DataHandler?) {
        self.handler = handler
        handler?(studySchedules)
    }
    
    func getAllStudyAllSchedule() {
        Network.shared.getAllStudyAllSchedule { result in
            switch result {
            case .success(let allStudyAllSchedule):
                self.allStudyAllSchedule = allStudyAllSchedule
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func studySchedule(at selectedDateComponents: DateComponents?) -> [StudyScheduleComing] {
        let studyScheduleAtSelectedDate = filtering(studySchedules, at: selectedDateComponents)
        
        return studyScheduleAtSelectedDate
    }

    func studySchedule(of studyID: ID, at selectedDateComponents: DateComponents?) -> [StudyScheduleComing]? {
        let studySchedule = studySchedules.filter { $0.studyID == "\(studyID)"}
        let studyScheduleAtSelectedDate = filtering(studySchedule, at: selectedDateComponents)

        return studyScheduleAtSelectedDate
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
    
    // MARK: - Helper
    
    private func filtering(_ studySchedule: [StudyScheduleComing], at selectedDateComponents: DateComponents?) -> [StudyScheduleComing] {
        return studySchedule.filter { studySchedule in
           
            let startDate = studySchedule.startDateAndTime
            let startDateComponents = startDate.convertToDateComponents([.year, .month, .day])
            
            let isSameDate = selectedDateComponents?.year == startDateComponents.year && selectedDateComponents?.month == startDateComponents.month && selectedDateComponents?.day == startDateComponents.day
            
            return isSameDate
        }
    }
}

// MARK: - StudyScheduleViewModel

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
