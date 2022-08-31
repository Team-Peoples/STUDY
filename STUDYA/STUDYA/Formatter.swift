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
