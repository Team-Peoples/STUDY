//
//  AttendancePopUpPeriodCalendarViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/06.
//

import UIKit

final class AttendancePopUpPeriodCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    var precedingDate = Date() - 2000000 //임시
    var followingDate = Date() - 200000
    lazy var precedingDateComponents: DateComponents? = precedingDate.convertToDateComponents()
    lazy var followingDateComponents: DateComponents? = followingDate.convertToDateComponents()
    var strSelectedDate = "2022.06.01"  //임시
    var strSelectedDate2 = "2022.06.11" //임시

    private var isPrecedingDateTurn = true
    
    weak var presentingVC: UIViewController?
    
    private let dimmingViewButton = UIButton(frame: .zero)
    private let popUpContainerView = UIView(backgroundColor: .systemBackground)
    private let upperContainerView = UIView(backgroundColor: .appColor(.background))
    private let titleLabel = CustomLabel(title: "조회 기간 설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let dismissButton: UIButton = {
        
        let button = UIButton()
        let image = UIImage(named: "Dismiss")
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    private lazy var precedingDateButton = CustomButton(fontSize: 16, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 30, normalBorderColor: .ppsGray2, normalTitle: strSelectedDate, selectedBackgroundColor: .daySelected, selectedTitleColor: .ppsGray1, selectedBorderColor: .keyColor2, width: 132, contentEdgeInsets: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25), target: self, action: #selector(precedingDateButtonTapped))
    private let waveLabel = CustomLabel(title: "~", tintColor: .ppsGray1, size: 16)
    private lazy var followingDateButton = CustomButton(fontSize: 16, isBold: false, normalBackgroundColor: .background, normalTitleColor: .ppsGray2, height: 30, normalBorderColor: .ppsGray2, normalTitle: strSelectedDate2, selectedBackgroundColor: .daySelected, selectedTitleColor: .ppsGray1, selectedBorderColor: .keyColor2, width: 132, contentEdgeInsets: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25), target: self, action: #selector(followingDateButtonTapped))
    private lazy var stackView: UIStackView = {
       
        let s = UIStackView(arrangedSubviews: [precedingDateButton, waveLabel, followingDateButton])
        
        s.axis = .horizontal
        s.distribution = .equalSpacing
        
        return s
    }()
    private lazy var calendarView: UICalendarView = {
        
        let calendarView = UICalendarView()
        
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.tintColor = .appColor(.keyColor1)
        calendarView.fontDesign = .rounded
        
        return calendarView
    }()
    private lazy var selectionSingleDate = UICalendarSelectionSingleDate(delegate: self)
    private let doneButton = BrandButton(title: "확인", isBold: true, isFill: false, fontSize: 16, height: 40)
    
    // MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionSingleDate.setSelected(precedingDateComponents, animated: true)
        calendarView.selectionBehavior = selectionSingleDate
        
        dimmingViewButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        precedingDateButton.isSelected = true
        
        configureViews()
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func precedingDateButtonTapped() {
        enablePrecedingButton()
    }
    
    @objc private func followingDateButtonTapped() {
        enableFollowingButton()
    }
    
    @objc private func doneButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func enablePrecedingButton() {
        precedingDateButton.isSelected = true
        followingDateButton.isSelected = false
    }
    
    private func enableFollowingButton() {
        precedingDateButton.isSelected = false
        followingDateButton.isSelected = true
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        view.addSubview(dimmingViewButton)
        view.addSubview(popUpContainerView)
        
        popUpContainerView.layer.cornerRadius = 24
        popUpContainerView.clipsToBounds = true
        popUpContainerView.backgroundColor = .systemBackground
        
        popUpContainerView.addSubview(upperContainerView)
        upperContainerView.addSubview(titleLabel)
        upperContainerView.addSubview(dismissButton)
        upperContainerView.addSubview(stackView)
        popUpContainerView.addSubview(calendarView)
        popUpContainerView.addSubview(doneButton)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        dimmingViewButton.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        popUpContainerView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Const.screenHeight * 0.65)
            make.width.equalTo(Const.screenWidth * 0.94)
        }
        upperContainerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(120)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(upperContainerView.snp.leading).inset(28)
            make.top.equalTo(upperContainerView.snp.top).inset(24)
        }
        dismissButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(upperContainerView).inset(16)
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
        }
        calendarView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(upperContainerView.snp.bottom)
            make.bottom.equalTo(doneButton.snp.top)
            make.leading.trailing.equalTo(popUpContainerView)
        }
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(popUpContainerView).inset(20)
            make.top.greaterThanOrEqualTo(calendarView.snp.bottom).offset(20)
        }
    }
}

extension AttendancePopUpPeriodCalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {

        if isPrecedingDateTurn {
//            dateComponents 저장하고
            enableFollowingButton()
            isPrecedingDateTurn = false
//            selectionSingleDate.setSelected(nil, animated: false)
        } else {
//            if 두번째로 선택한 날짜가 첫번째로 선택한 날짜보다 앞선다면 dateComponents를 첫번째날짜에 다시 저장하여 덮어씌우고 precede button 타이틀 바꾸기
//            else dateComp 저장하고 완료버튼 활성화
        }
        
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        let today = Date()  //여기서는 오늘 이후에는 선택해봤자 의미가 없기 땜에 오늘이 맞음.
//        let todayDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
        
        guard let dateComponents = dateComponents, let selectedDate = dateComponents.convertToDate() else { return false }
        
        if today < selectedDate { return false } else { return true }
    }
}
