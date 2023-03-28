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
