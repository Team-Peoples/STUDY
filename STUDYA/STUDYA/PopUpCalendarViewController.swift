//
//  PopUpCalendarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 12/1/22.
//

import UIKit
import SnapKit

class PopUpCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedDate: Date?
    weak var presentingVC: UIViewController?
    
    private let calendarType: PopUpCalendarType
    private let popUpContainerView = UIView(backgroundColor: .systemBackground)
    private let dismissButton: UIButton = {
        
        let button = UIButton()
        let image = UIImage(named: "Dismiss")
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    private let calendarView: UICalendarView = {
        
        let calendarView = UICalendarView()
        
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.tintColor = .appColor(.keyColor1)
        
        return calendarView
    }()
    
    // MARK: - Life Cycle
    
    init(type: PopUpCalendarType) {
        self.calendarType = type
        
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc func dismissButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        view.addSubview(popUpContainerView)
        
        popUpContainerView.layer.cornerRadius = 24
        popUpContainerView.addSubview(dismissButton)
        popUpContainerView.addSubview(calendarView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        popUpContainerView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
            make.width.equalTo(300)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(popUpContainerView).inset(16)
            make.height.width.equalTo(24)
            
        }
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom)
            make.leading.trailing.bottom.equalTo(popUpContainerView)
        }
    }
}

extension PopUpCalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        
        guard let presentingVC = presentingVC as? StudySchedulePriodFormViewController else { return }
    
        switch calendarType {
        case .open:
            presentingVC.studySchedule?.openDate = dateComponents?.date
            self.dismiss(animated: true)
        case .deadline:
            presentingVC.studySchedule?.deadlineDate = dateComponents?.date
            self.dismiss(animated: true)
        }
    }
}
