//
//  Formatter.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/31.
//

import Foundation

extension NumberFormatter {
    
    // MARK: - Properties
    static let decimalNumberFormatter: NumberFormatter = {
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    // MARK: - Methods
    
    func string(from number: Int) -> String? {
        return self.string(from: NSNumber(value: number))
    }
    
    func number(from text: String?) -> Int? {
        guard let text = text else { return nil }
    
        return self.number(from: text) as? Int
    }
}

extension DateFormatter {
    
    static let fullDateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
      
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter
    }()
    
    static let yearMonthDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy.MM"
        
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
    
    static let shortenDottedDateFormatter: DateFormatter = {
       
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yy.MM.dd"
        
        return dateFormatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()
    
    static let dayAndTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd HH:mm"
        
        return dateFormatter
    }()
}
