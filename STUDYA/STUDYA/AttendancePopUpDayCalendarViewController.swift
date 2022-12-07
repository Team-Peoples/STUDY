//
//  AttendancePopUpDayCalendarViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/06.
//

import UIKit

final class AttendancePopUpDayCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedDate: Date = Date() //임시
    lazy var selectedDateComponents: DateComponents? = Calendar.current.dateComponents([.year, .month, .day, .era, .calendar], from: selectedDate as Date)
//    lazy var selectedDateComponents = DateComponents(year: 2022, month: 12, day: 30)
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
    private lazy var calendarView: UICalendarView = {
        
        let calendarView = UICalendarView()
        
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.tintColor = .appColor(.keyColor1)
        calendarView.fontDesign = .rounded
        
//        selectionSingleDate.w(DateComponents(year: 2022, month: 12, day: 6), animated: true)
//        selectedDate.
        
        
        return calendarView
    }()
    private lazy var selectionSingleDate = UICalendarSelectionSingleDate(delegate: self)
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
        
        selectionSingleDate.setSelected(selectedDateComponents, animated: true)
        calendarView.selectionBehavior = selectionSingleDate
        
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
    
    private func daySelected() {
//        calendarView.
    }
}

extension AttendancePopUpDayCalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let today = Date()  //투데이가 아니라 원래는 선택되어있던 날짜를 가져오면 됨
        let todayDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
        guard let dateComponents = dateComponents else { return }
        
        if dateComponents.year == todayDateComponents.year
            && dateComponents.month == todayDateComponents.month
            && dateComponents.day == todayDateComponents.day {
            selectionSingleDate.setSelected(nil, animated: true)
            doneButton.fillOut(title: "완료")
        } else {
            doneButton.fillIn(title: "완료")
        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        let today = Date()  //여기서는 오늘 이후에는 선택해봤자 의미가 없기 땜에 오늘이 맞음.
//        let todayDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
        
        guard let dateComponents = dateComponents, let selectedDate = Calendar.current.date(from: dateComponents) else { return false }
        
        if today < selectedDate { return false } else { return true }
    }
}

extension Date {
    func dateToDateComponents() -> DateComponents {
        
        let com = Calendar.current.dateComponents([.year, .month, .day], from: self)
        
        return com
    }
}
