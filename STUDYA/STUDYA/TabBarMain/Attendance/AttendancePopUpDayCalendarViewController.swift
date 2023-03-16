//
//  AttendancePopUpDayCalendarViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/06.
//

import UIKit

final class AttendancePopUpDayCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    internal var selectedDate: Date?
    
    weak var viewModel: AttendancesModificationViewModel?
    weak var presentingVC: UIViewController?
    
    private let dimmingViewButton = UIButton(frame: .zero)
    private let popUpContainerView = UIView(backgroundColor: .systemBackground)
    private let titleLabel = CustomLabel(title: "조회 날짜 설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let dismissButton: UIButton = {
        
        let button = UIButton()
        let image = UIImage(named: "dismiss")
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    private lazy var calendarView = CustomCalendarView()
    private let doneButton = BrandButton(title: Constant.OK, isBold: true, isFill: false, fontSize: 16, height: 40)
    
    // MARK: - Life Cycle
    
    init(presentingVC: UIViewController, viewModel: AttendancesModificationViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        self.viewModel = viewModel
        self.presentingVC = presentingVC
        
        guard let date = DateFormatter.dashedDateFormatter.date(from: viewModel.selectedDate.value) else { return }
        calendarView.select(date: date)
        
        let today = Date()
        calendarView.setMaximumDate(today)
        calendarView.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimmingViewButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.isEnabled = false
        
        configureViews()
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        guard let selectedDateComponents = selectedDate?.convertToDateComponents([.year, .month, .day]),
              let year = selectedDateComponents.year,
              let month = selectedDateComponents.month,
              let day = selectedDateComponents.day else { return }
        
        let dateString = String(format: "%04d-%02d-%02d", year, month, day)
        viewModel?.selectedDate = Observable(dateString)
        viewModel?.getAllMembersAttendanceOn(date: dateString)
        
        self.dismiss(animated: true)
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
            make.height.equalTo(450)
            make.width.equalTo(Constant.screenWidth * 0.94)
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

extension AttendancePopUpDayCalendarViewController: CustomCalendarViewDelegate {
    
    func calendarView(didselectAt date: Date) {
        guard let selectedDateComponents = selectedDate?.convertToDateComponents([.year, .month, .day]) else { return }
        let dateComponents = date.convertToDateComponents([.year, .month, .day])
        
        if dateComponents == selectedDateComponents {
            
//                self.selectedDateComponents = nil
//                selectionSingleDate.setSelected(nil, animated: true)
            // domb: 무엇을 하려는건지 몰라서 참고 함수만 적어놨어~
//                calendarView.select(date: <#T##Date#>)
            doneButton.fillOut(title: Constant.done)
            doneButton.isEnabled = false
        } else {
            doneButton.fillIn(title: Constant.done)
            doneButton.isEnabled = true
        }
    }
}
