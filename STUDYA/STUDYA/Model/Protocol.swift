//
//  Protocol.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/06.
//

import UIKit

protocol Navigatable: UIViewController {

}

extension Navigatable {
    func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    func present(_ vc: UIViewController) {
        present(vc, animated: true)
    }
    func dismiss() {
        dismiss(animated: true)
    }
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}

protocol BottomSheetAddable: UIViewController {
    
}

extension BottomSheetAddable {
    func presentBottomSheet(vc: UIViewController, detent: CGFloat, prefersGrabberVisible: Bool) {
        
        guard let sheet = vc.sheetPresentationController else { return }
        
        sheet.detents = [ .custom { _ in return detent }]
        sheet.preferredCornerRadius = 24
        sheet.prefersGrabberVisible = prefersGrabberVisible
        
        present(vc, animated: true)
    }
}

protocol SwitchSyncable {
    func syncSwitchWith(nextVC: SwitchableViewController)
}

protocol GrowingCellProtocol: AnyObject {
    func updateHeightOfRow(_ cell: ToDoItemTableViewCell, _ textView: UITextView)
}
