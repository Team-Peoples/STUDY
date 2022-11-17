//
//  AttendanceStatusReusableView.swift
//  STUDYA
//
//  Created by 서동운 on 11/17/22.
//

import UIKit
import MultiProgressView

class AttendanceStatusReusableView: UICollectionReusableView {
    
    private lazy var progressView: MultiProgressView = {
      let progress = MultiProgressView()
        progress.trackBackgroundColor = .appColor(.ppsGray2)
      progress.lineCap = .round
      progress.cornerRadius = 24
      return progress
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
