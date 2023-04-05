//
//  StudyScheduleViewModel.swift
//  STUDYA
//
//  Created by 서동운 on 3/6/23.
//

import Foundation

// MARK: - StudyScheduleViewModel

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
    func mappingStudyScheduleForIncludingStudyID() -> [StudySchedule] {
        let mappedStudySchedule = self.flatMap { id, studySchedules in
            studySchedules.map {
                StudySchedule(studyName: $0.studyName, studyScheduleID: $0.studyScheduleID, studyID: id, topic: $0.topic, place: $0.place, startDateAndTime: $0.startDateAndTime, endDateAndTime: $0.endDateAndTime, repeatOption: $0.repeatOption)
            }
        }
        return mappedStudySchedule
    }
}

// MARK: - StudySchedulePostingViewModel

class StudySchedulePostingViewModel: ViewModel {
    typealias Model = StudySchedulePosting
    
    var studySchedule: StudySchedulePosting {
        didSet {
            print(studySchedule)
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

extension [StudySchedule] {
    func filteredStudySchedule(at date: Date) -> [StudySchedule]  {
        
        let filteredStudySchedule = self.filter { studySchedule in
            studySchedule.startDateAndTime.isSameDay(as: date)
        }
        return filteredStudySchedule
    }
    
    func filterStudySchedule(by studyID: ID?) -> [StudySchedule] {
        guard let studyID = studyID else { return [] }
        let filteredStudySchedule = self.filter { studySchedule in
            studySchedule.studyID == "\(studyID)"
        }
        return filteredStudySchedule
    }
}
