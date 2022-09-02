//
//  Formatter.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/31.
//

import Foundation

final class Formatter {
    static func formatIntoDecimal(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    static func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Date Format

extension Date {
    func formatToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.string(from: self)
    }
}
