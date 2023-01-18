//
//  Formatter.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/31.
//

import Foundation

final class Formatter {
    
    static func formatIntoDecimal(number: Int) -> String? {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    static func formatIntoNoneDecimal(_ text: String?) -> Int? {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let text = text else { return nil }
        
        return numberFormatter.number(from: text) as? Int
    }
}

extension DateFormatter {
    
    static let myDateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
      
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter
    }()
    
    static let dashedDateFormatter: DateFormatter = {
       
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    static let dottedDateFormatter: DateFormatter = {
       
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter
    }()

//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//
//    let dateString = "2022-12-05"
//    if let date = dateFormatter.date(from: dateString) {
//        print(date)
//    }
    
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "HH:mm"
//
//    let timeString = "23:30"
//    if let time = dateFormatter.date(from: timeString) {
//        // 오늘 날짜를 구합니다.
//        let today = Calendar.current.startOfDay(for: Date())
//        // 오늘 날짜와 시간을 결합해 `Date`로 변환합니다.
//        let date = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: time), minute: Calendar.current.component(.minute, from: time), second: 0, of: today)
//        print(date)
//    }
}

// MARK: - Date Format

extension Date {
    enum Format: String {
        case announcementDateFormat = "MMM dd월 EEEE"
        case dottedFormat = "YYYY.MM.dd"
        case dashedFormat = "yyyy-MM-dd"
    }
    
    func formatToString(format: Format) -> String {
        
        let dateformatter = DateFormatter()
        dateformatter.calendar = Calendar.current
        dateformatter.dateFormat = format.rawValue
        
        return dateformatter.string(from: self)
    }
}

extension String {
    func formatToDate() -> Date? {
        
        let dateformatter = DateFormatter()
        dateformatter.calendar = Calendar.current
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        return dateformatter.date(from: self)
    }
}

struct TimeFormatter {
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    private init() { }
}

