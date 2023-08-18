//
//  CalendarTimePicker.swift
//  STUDYA
//
//  Created by 서동운 on 3/16/23.
//

import UIKit

final class TimePicker: UIDatePicker {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTimePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTimePicker() {
        calendar = Calendar.current
        datePickerMode = .time
        preferredDatePickerStyle = .wheels
        minuteInterval = 5
        locale = Locale(identifier: "en_gb")
    }
}
