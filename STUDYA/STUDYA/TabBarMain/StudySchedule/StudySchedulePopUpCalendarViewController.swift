//
//  StudySchedulePopUpCalendarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 12/1/22.
//

import UIKit
import SnapKit

class StudySchedulePopUpCalendarViewController: UIViewController {
    
    // MARK: - Properties

    enum PopUpCalendarType {
        case start
        case end
    }
    
    let viewModel: StudySchedulePostingViewModel
    let selectedDate: Date
    
    var startDate: Date?
    var endDate: Date?

    private let calendarType: PopUpCalendarType
    private let button = UIButton(frame: .zero)
    private let popUpContainerView = UIView(backgroundColor: .white)
    private let dismissButton = UIButton(image: UIImage(named: "dismiss"))
    private let calendarView = CustomCalendarView()
    
    // MARK: - Life Cycle
    
    init(type: PopUpCalendarType, selectedDate: Date, viewModel: StudySchedulePostingViewModel) {
        self.calendarType = type
        self.selectedDate = selectedDate
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.select(date: selectedDate)
        
        if calendarType == .end {
            calendarView.setMinimumDate(startDate)
        }
        
        configureViews()
    }
    
    // MARK: - Actions
    
    @objc func dismissButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Configure
    private func configureViews() {
        
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        button.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        addSubviewsWithConstraints()
    }
    
    private func addSubviewsWithConstraints() {
        
        view.addSubview(button)
        view.addSubview(popUpContainerView)
        
        popUpContainerView.layer.cornerRadius = 24
        popUpContainerView.addSubview(dismissButton)
        popUpContainerView.addSubview(calendarView)
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        popUpContainerView.snp.makeConstraints { make in
            make.center.equalTo(view)
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

extension StudySchedulePopUpCalendarViewController {
    
    func configure(viewModel: StudySchedulePostingViewModel, date: Date) {
        switch calendarType {
        case .start:
            viewModel.studySchedule.startDate = DateFormatter.dashedDateFormatter.string(from: date)
            
            if viewModel.studySchedule.repeatOption != .norepeat {
                viewModel.studySchedule.repeatEndDate = DateFormatter.dashedDateFormatter.string(from: date)
            }
            self.dismiss(animated: true)
        case .end:
            viewModel.studySchedule.repeatEndDate = DateFormatter.dashedDateFormatter.string(from: date)
            
            self.dismiss(animated: true)
        }
    }
}

extension StudySchedulePopUpCalendarViewController: CustomCalendarViewDelegate {
    func calendarView(didselectAt date: Date) {
        self.configure(viewModel: viewModel, date: date)
    }
}
