//
//  Protocol.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/06.
//

import UIKit

protocol Navigatable {
    func push(vc: UIViewController)
    func present(vc: UIViewController)
}

protocol BottomSheetAddable: UIViewController {
    var height: Int? { get }
    var bottomVC: UIViewController? { get }
    func addSheet(height: CGFloat)
}

extension BottomSheetAddable {
    func addSheet(height: CGFloat) {
        guard let sheet = bottomVC?.sheetPresentationController else { return }
        
        sheet.detents = [ .custom { _ in return height }]
        sheet.preferredCornerRadius = 24
        sheet.prefersGrabberVisible = true
    }
}
