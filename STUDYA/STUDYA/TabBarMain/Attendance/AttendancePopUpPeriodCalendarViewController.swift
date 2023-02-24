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
    var followingDate = Date()
    lazy var precedingDateComponents: DateComponents? = precedingDate.convertToDateComponents([.year, .month, .day]) {
        didSet {
            
            guard let precedingDateComponents = precedingDateComponents,
                  let year = precedingDateComponents.year,
                  let month = precedingDateComponents.month,
                  let day = precedingDateComponents.day else { return }
            
            precedingDateButton.setTitle("\(year).\(month).\(day)", for: .normal)
        }
    }
    lazy var followingDateComponents: DateComponents? = followingDate.convertToDateComponents([.year, .month, .day]) {
        didSet {
            
            guard let followingDateComponents = followingDateComponents,
                  let year = followingDateComponents.year,
                  let month = followingDateComponents.month,
                  let day = followingDateComponents.day else { return }
            
            followingDateButton.setTitle("\(year).\(month).\(day)", for: .normal)
        }
    }
    
    var strSelectedDate = "2022.06.01"  //임시
    var strSelectedDate2 = "2022.06.11" //임시

    private var isPrecedingDateTurn = true
    
    internal weak var dateLabelUpdatableDelegate: DateLabelUpdatable?
    
    private let dimmingViewButton = UIButton(frame: .zero)
    private let popUpContainerView = UIView(backgroundColor: .systemBackground)
    private let upperContainerView = UIView(backgroundColor: .appColor(.background))
    private let titleLabel = CustomLabel(title: "조회 기간 설정", tintColor: .ppsBlack, size: 16, isBold: true)
    private let dismissButton: UIButton = {
        
        let button = UIButton()
        let image = UIImage(named: "dismiss")
        
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
    private lazy var calendarView = CustomCalendarView()
    private let doneButton = BrandButton(title: Constant.OK, isBold: true, isFill: false, fontSize: 16, height: 40)
    
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
        
        calendarView.select(date: precedingDate)
        
        let today = Date()
        calendarView.maximumDate = today
        
        calendarView.selectionAction = { [self] (date) in
            let dateComponents = date.convertToDateComponents([.year, .month, .day])
            if isPrecedingDateTurn {
                precedingDateComponents = dateComponents
                enableFollowingButton()
                doneButton.fillOut(title: Constant.OK)
                doneButton.isEnabled = false
                isPrecedingDateTurn = false
            } else {
                if date < precedingDate {
                    precedingDateComponents = dateComponents
                    doneButton.fillOut(title: Constant.OK)
                    doneButton.isEnabled = false
                } else {
                    followingDateComponents = dateComponents
                    doneButton.fillIn(title: Constant.OK)
                    doneButton.isEnabled = true
                }
            }
        }
        

        dimmingViewButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.isEnabled = false
        precedingDateButton.isSelected = true
        
        configureViews()
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func precedingDateButtonTapped() {
        isPrecedingDateTurn = true
        enablePrecedingButton()
    }
    
    @objc private func followingDateButtonTapped() {
        enableFollowingButton()
    }
    
    @objc private func doneButtonTapped() {
        guard let precedingDate = precedingDateComponents?.convertToDate(), let followingDate = followingDateComponents?.convertToDate() else { return }
        dateLabelUpdatableDelegate?.updateDateLabels(preceding: precedingDate, following: followingDate)
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
            make.height.equalTo(530)
            make.width.equalTo(Constant.screenWidth * 0.94)
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
