//
//  CustomCalendar.swift
//  STUDYA
//
//  Created by 서동운 on 2/23/23.
//

import UIKit
import SnapKit
import FSCalendar

class CustomCalendarView: UIView {
    
    // MARK: - Properties
   
    var 날짜별_갯수별_스터디아이디컬러: [DateComponents: ID]?
    var minimumDate: Date?
    var maximumDate: Date?
    var notificationName: Notification.Name?
    var selectionAction: ((Date) -> Void) = {(Date) in }
    private(set) lazy var selectedDate: Date? = calendar.selectedDate
    
    private let datesWithMultipleEvents = [String]()
    
    weak var CalendarDelegate: FSCalendarDelegate!
    weak var CalendarDataSource: FSCalendarDataSource!
    
    private let calendar = FSCalendar()
    
    /// CalendarHeaderView
    private let customHeaderView = UIView(backgroundColor: .white)
    private let monthBackgroundView: UIView = UIView(backgroundColor: .appColor(.background), cornerRadius: 26 / 2)
    private let monthLabel: UILabel = {
        
        let titleLabel = UILabel(backgroundColor: UIColor.clear)
        let today = Date()
        titleLabel.text = DateFormatter.yearMonthDateFormatter.string(from: today)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return titleLabel
    }()
    lazy var leftButton: UIButton = {
        
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "leftArrow"), for: .normal)
        button.layer.cornerRadius = 20 / 2
        button.backgroundColor = .appColor(.keyColor3)
        button.addTarget(self, action: #selector(moveToPreviousMonth), for: .touchUpInside)
        
        return button
    }()
    lazy var rightButton: UIButton = {
        
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "rightArrow"), for: .normal)
        button.layer.cornerRadius = 20 / 2
        button.backgroundColor = .appColor(.keyColor3)
        button.addTarget(self, action: #selector(moveToNextMonth), for: .touchUpInside)
        
        return button
    }()
    
    
    private let weekdaySeparater = UIView(backgroundColor: .appColor(.keyColor3))
    
    // MARK: - Life Cycle
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCalendar()
        
        setCalendarWeekdayView()
        setCalendarDaysView()
        
        configureViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func moveToPreviousMonth() {
        
        let currentPage = calendar.currentPage
        let previousPage = Calendar.current.date(byAdding: .month, value: -1, to: currentPage)!
        calendar.setCurrentPage(previousPage, animated: true)
    }

    @objc private func moveToNextMonth() {
        
        let currentPage = calendar.currentPage
        let previousPage = Calendar.current.date(byAdding: .month, value: +1, to: currentPage)!
        calendar.setCurrentPage(previousPage, animated: true)
    }
    
    func select(date: Date) {
        calendar.select(date)
    }
    
    private func initCalendar() {

        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.headerHeight = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: CustomCalendarCell.identifier)
    }
    
    private func setCalendarWeekdayView() {
        
        calendar.weekdayHeight = 40
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16)
        calendar.appearance.weekdayTextColor = .appColor(.keyColor2)
    }
    
    private func setCalendarDaysView() {
        
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 16)
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        addSubview(customHeaderView)
        addSubview(calendar)
        
        calendar.calendarWeekdayView.addSubview(weekdaySeparater)

        customHeaderView.addSubview(monthBackgroundView)
        
        monthBackgroundView.addSubview(monthLabel)
        monthBackgroundView.addSubview(leftButton)
        monthBackgroundView.addSubview(rightButton)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        monthLabel.snp.makeConstraints { make in
            make.center.equalTo(monthBackgroundView)
        }

        monthBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(166)
            make.height.equalTo(26)
            make.top.equalTo(customHeaderView).offset(10)
            make.centerX.equalTo(customHeaderView)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalTo(monthBackgroundView)
            make.leading.equalTo(monthBackgroundView).inset(3)
        }
        
        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalTo(monthBackgroundView)
            make.trailing.equalTo(monthBackgroundView).inset(3)
        }
        
        customHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        weekdaySeparater.snp.makeConstraints { make in
            make.leading.trailing.equalTo(calendar).inset(10)
            make.height.equalTo(1)
            make.bottom.equalTo(calendar.calendarWeekdayView.snp.bottom)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(customHeaderView.snp.bottom)
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

// MARK: - FSCalendarDataSource

extension CustomCalendarView: FSCalendarDataSource {
    
    // 커스텀 셀 구성
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at monthPosition: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CustomCalendarCell.identifier, for: date, at: monthPosition) as! CustomCalendarCell
        // 셀의 설정
        return cell
    }
    
    // 캘린더에서 볼수있는 미니멈 날짜
    func minimumDate(for calendar: FSCalendar) -> Date {
        if let minimumDate = minimumDate {
            return minimumDate
        } else {
            let now = Date()
            let tenYearsAgo = Calendar.current.date(byAdding: .year, value: -10, to: now)!
            return tenYearsAgo
        }
    }
    
     // 캘린더에서 볼수있는 맥시멈 날짜
    func maximumDate(for calendar: FSCalendar) -> Date {
        if let maximumDate = maximumDate {
            return maximumDate
        } else {
            let now = Date()
            let tenYearsLater = Calendar.current.date(byAdding: .year, value: 10, to: now)!
            return tenYearsLater
        }
    }
    
    // 이벤트 발생 날짜에 필요한 만큼 개수 반환 (최대 3개)
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let eventDay = date.convertToDateComponents([.year, .month, .day])
        // 헤당 날짜의 일정 갯수
        let studySchedules = 날짜별_갯수별_스터디아이디컬러?.filter { (date, id) in
            date == eventDay
        }
        let studySchedulesCount = studySchedules?.count
        return studySchedulesCount ?? 0
    }
}

// MARK: - FSCalendarDelegate

extension CustomCalendarView: FSCalendarDelegate {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let today = calendar.currentPage
        monthLabel.text = DateFormatter.yearMonthDateFormatter.string(from: today)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectionAction(date)
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let dateComponents = date.convertToDateComponents([.year, .month, .day])
        let today = Date().convertToDateComponents([.year, .month, .day])
        let todayCell = cell as? CustomCalendarCell
        if dateComponents == today {
            todayCell?.setTodayBorderLayerIsHidden(false)
        } else {
            todayCell?.setTodayBorderLayerIsHidden(true)
        }
    }
}
// MARK: - FSCalendarDelegateAppearance

extension CustomCalendarView: FSCalendarDelegateAppearance {

    // 스터디 스케쥴 북마크컬러에따라 컬러 지정
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = DateFormatter().string(from: date)
        if self.datesWithMultipleEvents.contains(key) {
            // domb: 스케쥴의 bookmark컬러 가져와서 리턴
            return [UIColor.magenta, UIColor.black]
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.clear // nil을 해주어도 blue로 설정되어있어서 clear로 해주어야 함.
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return UIColor.black // nil을 해주어도 white로 설정되어있어서 black로 해주어야 함.
    }
}


// MARK: - CustomCalendarCell

class CustomCalendarCell: FSCalendarCell {
    
    // MARK: - Properties
    
    static let identifier = "CustomCalendarCell"
    
    private let selectionLayer = CAShapeLayer()
    private let todayBorderLayer = CAShapeLayer()
    
    override var isSelected: Bool {
        didSet {
            selectionLayer.isHidden = !isSelected // 선택된 상태에 따라 layer 보이기/숨기기
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 셀 선택시 보여줄 layer 설정
        selectionLayer.fillColor = UIColor.appColor(.daySelected).cgColor
        selectionLayer.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 6.0, dy: 1.0), cornerRadius: 6).cgPath
        selectionLayer.isHidden = true
        
        // 셀 테두리 layer 설정
        todayBorderLayer.fillColor = UIColor.clear.cgColor
        todayBorderLayer.strokeColor = UIColor.appColor(.keyColor1).cgColor
        todayBorderLayer.lineWidth = 1
        todayBorderLayer.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 6.0, dy: 1.0), cornerRadius: 6).cgPath
        todayBorderLayer.isHidden = true
        
        self.layer.insertSublayer(todayBorderLayer, at: 0)
        self.layer.insertSublayer(selectionLayer, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions
    
    func setTodayBorderLayerIsHidden(_ isHidden: Bool) {
        todayBorderLayer.isHidden = isHidden
    }
}
