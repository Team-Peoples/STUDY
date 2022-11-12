//
//  ScheduleTableView.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/21.
//

import UIKit

class ScheduleTableView: UITableView {

    required init() {
        super.init(frame: .zero, style: .plain)
        
        backgroundColor = .systemBackground
        
        alwaysBounceVertical = true
        keyboardDismissMode = .interactive
        separatorStyle = .none
        
        registerCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }
    
    func registerCell() {
        register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleTableViewCell")
    }
    
//    public func scrollToBottom(animated: Bool) {
//        guard contentSize.height > bounds.size.height else { return }
//        setContentOffset(CGPoint(x: 0, y: (contentSize.height - bounds.size.height) + (contentInset.bottom)), animated: animated)
//    }
}
