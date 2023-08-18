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
    
    
    
    var error: Observable<PeoplesError> = Observable(.noError)
    
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
                self.error.value = error
            }
        }
    }
    
    func deleteStudySchedule(id studyScheduleID: ID, deleteRepeatedSchedule: Bool, successHandler: @escaping () -> Void) {
        Network.shared.deleteStudySchedule(studyScheduleID, deleteRepeatSchedule: deleteRepeatedSchedule) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                self.error.value = error
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

enum TimeType {
    case startTime
    case endTime
}

enum DuplicateStatus{
    case duplicated
    case NotDuplicated
}


class StudySchedulePostingViewModel: ViewModel {
    typealias Model = StudySchedulePosting
    
    var studySchedule: StudySchedulePosting {
        didSet {
            print(studySchedule)
            handler?(studySchedule)
        }
    }
    
    var alreadyExistStudyScheduleTimeTable: [DashedDate: [TimeRange]]?
    
    func checkDuplicate(inputtedDate: DashedDate) -> DuplicateStatus {
        guard let selectedStartTime = studySchedule.startTime,
              let selectedEndTime = studySchedule.endTime else { return .NotDuplicated }
        
        guard let alreadyExistStudyScheduleTimeList = alreadyExistStudyScheduleTimeTable?[inputtedDate] else { return .NotDuplicated }
        
        let isDuplicated = alreadyExistStudyScheduleTimeList.contains(where: { (startTime, endTime) in
            
            if selectedStartTime >= startTime && selectedStartTime < endTime {
                return true
            } else if selectedEndTime > startTime && selectedEndTime <= endTime {
                return true
            } else if selectedStartTime <= startTime && selectedEndTime >= endTime {
                return true
            } else {
                return false
            }
        })
        
        if isDuplicated {
            return .duplicated
        } else {
            return .NotDuplicated
        }
    }
    
    func checkDuplicate(inputtedTime: String, when selectedTimeType: TimeType) -> DuplicateStatus {
        let selectedStartDate = studySchedule.startDate
        
        guard let alreadyExistStudyScheduleTimeList = alreadyExistStudyScheduleTimeTable?[selectedStartDate] else { return .NotDuplicated }
        
        let isDuplicated = alreadyExistStudyScheduleTimeList.contains(where: { (startTime, endTime) in
            
            switch selectedTimeType {
            case .startTime:
                guard let selectedEndTime = studySchedule.endTime else {
                    return inputtedTime >= startTime && inputtedTime < endTime
                }
                
                if inputtedTime >= startTime && inputtedTime < endTime {
                    return true
                } else if inputtedTime < startTime && selectedEndTime > startTime {
                    return true
                } else {
                    return false
                }
            case .endTime:
                guard let selectedStartTime = studySchedule.startTime else {
                    return inputtedTime > startTime && inputtedTime <= endTime
                }
                
                if inputtedTime > startTime && inputtedTime <= endTime {
                    return true
                } else if selectedStartTime < startTime && inputtedTime > startTime {
                    return true
                } else {
                    return false
                }
            }
        })
        
        if isDuplicated {
            return .duplicated
        } else {
            return .NotDuplicated
        }
    }
        
    var error: Observable<PeoplesError> = Observable(.noError)
    
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
                self.error.value = error
            }
        }
    }
    
    func updateStudySchedule(successHandler: @escaping () -> Void) {
        Network.shared.updateStudySchedule(studySchedule) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                self.error.value = error
            }
        }
    }
}

extension [StudySchedule] {
    func filterStudySchedule(by date: Date) -> [StudySchedule]  {
        
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
    
    func convertDashedDateAndTimeTable() -> [DashedDate: [TimeRange]] {
        
        var studyScheduleTimeTable = [DashedDate: [TimeRange]]()
        
        self.forEach { studySchedule in
            let studyScheduleStartDay = studySchedule.startDateAndTime
            let startDate = DateFormatter.dashedDateFormatter.string(from: studyScheduleStartDay)
            let startTime = DateFormatter.timeFormatter.string(from: studyScheduleStartDay)
            let endTime = DateFormatter.timeFormatter.string(from: studySchedule.endDateAndTime)
            
            if studyScheduleTimeTable[startDate] == nil {
                studyScheduleTimeTable[startDate] = [(StartTime: startTime, EndTime: endTime)]
            } else {
                studyScheduleTimeTable[startDate]?.append((StartTime: startTime, EndTime: endTime))
            }
        }
        
        return studyScheduleTimeTable
    }
}
