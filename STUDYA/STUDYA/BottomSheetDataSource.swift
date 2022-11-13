//
//  BottomSheetDataSource.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import Foundation

class CalendarBottomSheetDatasource: UBottomSheetCoordinatorDataSource {
    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
        return [0.12, 0.6].map{$0 * availableHeight}
    }
    
    func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
        return availableHeight * 0.6
    }
}

class MemberBottomSheetDataSource: UBottomSheetCoordinatorDataSource {
    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
        return [0.94, 0.5].map{ $0 * availableHeight }
    }
    
    func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
        return availableHeight * 0.94
    }
}
