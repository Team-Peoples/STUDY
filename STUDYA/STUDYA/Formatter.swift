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
}

// MARK: - Date Format

extension Date {
    enum Lang {
        case kor
        case eng
    }
    
    func formatToString(language: Lang) -> String {
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
