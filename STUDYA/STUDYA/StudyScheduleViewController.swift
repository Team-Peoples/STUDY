//
//  StudyScheduleViewController.swift
//  STUDYA
//
//  Created by EHDDOMB on 11/22/22.
//

import UIKit

class StudyScheduleViewController: UIViewController {
    
    weak var presentingVC: UIViewController?
    
    let calendarView: UICalendarView = {
        let c = UICalendarView()
        
        c.calendar = Calendar(identifier: .gregorian)
        c.tintColor = .appColor(.keyColor1)
        
        return c
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(calendarView)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        setConstraints()
        
        let vcToPresent = StudyScheduleBottomSheetController()
        vcToPresent.isModalInPresentation = true
        if let sheet = vcToPresent.sheetPresentationController {
            
            sheet.detents = [ .custom(identifier: .small) { _ in return 300 }, .large() ]
            
            sheet.preferredCornerRadius = 10
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .small
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }
        
        present(vcToPresent, animated: true, completion: nil)
    }
    
    private func setConstraints() {
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)
        }
    }
    
    deinit {
        presentingVC?.dismiss(animated: true)
    }
}

extension UISheetPresentationController.Detent.Identifier {
    
    
    @available(iOS 15.0, *)
    public static let small: UISheetPresentationController.Detent.Identifier = .init("small")
}

extension StudyScheduleViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return.default()
    }
}
extension StudyScheduleViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
    }
}
