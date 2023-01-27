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

    lazy var selectedDateComponents = selectedDate.convertToDateComponents([.year, .month, .day])
    var selectedDate: Date
    weak var presentingVC: UIViewController?
    lazy var startDate: Date = Date()

    private let calendarType: PopUpCalendarType
    private let button = UIButton(frame: .zero)
    private let popUpContainerView = UIView(backgroundColor: .systemBackground)
    private let dismissButton: UIButton = {
        
        let button = UIButton()
        let image = UIImage(named: "dismiss")
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    private let calendarView = PeoplesCalendarView()
    
    // MARK: - Life Cycle
    
    init(type: PopUpCalendarType, selectedDate: Date) {
        self.calendarType = type
        self.selectedDate = selectedDate
        
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen    
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectionDelegate = UICalendarSelectionSingleDate(delegate: self)
        selectionDelegate.selectedDate?.calendar = Calendar.current
        
        calendarView.selectionBehavior = selectionDelegate
        
        if calendarType == .start {
            selectionDelegate.setSelected(selectedDateComponents, animated: false)
        }
        
        button.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        
        configureViews()
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc func dismissButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Configure
    private func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        view.addSubview(button)
        view.addSubview(popUpContainerView)
        
        popUpContainerView.layer.cornerRadius = 24
        popUpContainerView.addSubview(dismissButton)
        popUpContainerView.addSubview(calendarView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
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
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        
        switch calendarType {
        case .start:
            return true
        case .end:
            
            guard let date = dateComponents?.date else { fatalError() }
            
            if date < startDate {
                return false
            } else {
                return true
            }
        }
    }
   
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let date = dateComponents?.date else { fatalError() }
        
        if let presentingVC = presentingVC as? CreatingStudySchedulePriodFormViewController {
            
            switch calendarType {
            case .start:

                presentingVC.studyScheduleViewModel.studySchedule.startDate = DateFormatter.dashedDateFormatter.string(from: date)
                
                // 모두 선택했다가 시작날짜를 조정하는 경우 반복여부가 설정되어있다면, 반복일정 끝나는 날짜를 선택날짜로 변경
                if presentingVC.studyScheduleViewModel.studySchedule.repeatOption != "" {
                    presentingVC.studyScheduleViewModel.studySchedule.repeatEndDate = DateFormatter.dashedDateFormatter.string(from: date)
                }
                
                self.dismiss(animated: true)
            case .end:
                
                presentingVC.studyScheduleViewModel.studySchedule.repeatEndDate = DateFormatter.dashedDateFormatter.string(from: date)
                
                self.dismiss(animated: true)
            }
        } else if let presentingVC = presentingVC as? EditingStudySchduleViewController {
            switch calendarType {
            case .start:
                presentingVC.editingStudyScheduleViewModel.studySchedule.startDate = DateFormatter.dashedDateFormatter.string(from: date)
                
                // 모두 선택했다가 시작날짜를 조정하는 경우 반복여부가 설정되어있다면, 반복일정 끝나는 날짜를 선택날짜로 변경
                if  presentingVC.editingStudyScheduleViewModel.studySchedule.repeatOption != "" {
                    presentingVC.editingStudyScheduleViewModel.studySchedule.repeatEndDate = DateFormatter.dashedDateFormatter.string(from: date)
                }
                
                self.dismiss(animated: true)
            case .end:
                
                presentingVC.editingStudyScheduleViewModel.studySchedule.repeatEndDate = DateFormatter.dashedDateFormatter.string(from: date)
                
                self.dismiss(animated: true)
            }
        }
    }
}
