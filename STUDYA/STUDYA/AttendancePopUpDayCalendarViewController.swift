//
//  AttendancePopUpDayCalendarViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/06.
//

import UIKit

final class AttendancePopUpDayCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedDate: Date?
    weak var presentingVC: UIViewController?
    
    private let dimmingViewButton = UIButton(frame: .zero)
    private let popUpContainerView = UIView(backgroundColor: .systemBackground)
    private let titleLabel = CustomLabel(title: "조회 날짜 설정", tintColor: .ppsBlack, size: 16, isBold: true)
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
    private let doneButton = BrandButton(title: "확인", isBold: true, isFill: false, fontSize: 16, height: 40)
    
    // MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print(#function)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        
        dimmingViewButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        configureViews()
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        print(#function)
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        view.addSubview(dimmingViewButton)
        view.addSubview(popUpContainerView)
        
        popUpContainerView.layer.cornerRadius = 24
        popUpContainerView.backgroundColor = .systemBackground
        
        popUpContainerView.addSubview(dismissButton)
        popUpContainerView.addSubview(calendarView)
        popUpContainerView.addSubview(titleLabel)
        popUpContainerView.addSubview(doneButton)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        dimmingViewButton.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        popUpContainerView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Const.screenHeight * 0.56)
            make.width.equalTo(Const.screenWidth * 0.94)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(popUpContainerView.snp.leading).inset(28)
            make.top.equalTo(popUpContainerView.snp.top).inset(24)
        }
        dismissButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(popUpContainerView).inset(16)
        }
        calendarView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
            make.bottom.equalTo(doneButton.snp.top)
            make.leading.trailing.equalTo(popUpContainerView)
        }
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(popUpContainerView).inset(20)
            make.top.greaterThanOrEqualTo(calendarView.snp.bottom).offset(20)
        }
    }
}

extension AttendancePopUpDayCalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        
        guard let presentingVC = presentingVC as? StudySchedulePriodFormViewController else { return }
    
//        switch calendarType {
//        case .open:
//            presentingVC.studySchedule?.openDate = dateComponents?.date
//            self.dismiss(animated: true)
//        case .deadline:
//            presentingVC.studySchedule?.deadlineDate = dateComponents?.date
//            self.dismiss(animated: true)
//        }
    }
}
