//
//  Formatter.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/31.
//

import Foundation

// domb: 참조타입의 전역함수를 사용하는 Formatter 클래스, 클래스 선언이유?
final class Formatter {
    static func formatIntoDecimal(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

// MARK: - Date Format

extension Date {
    enum Language {
        case kor
        case eng
    }
    
    func formatToString(language: Language) -> String {
        switch language {
            case .kor:
                
                let dateformatter = DateFormatter()
                dateformatter.locale = Locale(identifier: "ko_KR")
                dateformatter.dateFormat = "MMM dd월 EEEE "
                return dateformatter.string(from: self)
            case .eng:
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY.MM.dd"
                return dateFormatter.string(from: self)
        }
    }
}

struct TimeFormatter {
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_gb")

        return dateFormatter
    }()
    
    private init() { }
}
