//
//  MainCalendarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import UIKit
import FSCalendar

@available(iOS 16.0, *)

final class MainCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    private let datesWithMultipleEvents = [String]()
    
    let studyAllScheduleViewModel = StudyAllScheduleViewModel()
    
    var sheetCoordinator: UBottomSheetCoordinator!
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    let calendarView = CustomCalendarView()
    let calendarBottomSheetVC = MainCalendarBottomSheetViewController()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studyAllScheduleViewModel.getAllStudyAllSchedule()
        studyAllScheduleViewModel.bind { [self] _ in
            // 데이터를 가져와서 달력의 해당 날짜에 스터디 스케쥴이 있으면 점 개수, 북마크컬러로 보여주기
            // 캘린더 날을 선택하면 노티로 각 테이블 뷰에 전달하기
        }
        
        calendarView.select(date: Date())
        calendarView.dateSelectAction = { (date) in
            NotificationCenter.default.post(name: .mainCalenderDateTapped, object: date)
        }
        
        dataSource = CalendarBottomSheetDatasource()
        title = "나의 캘린더"
        
        configureViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        studyAllScheduleViewModel.getAllStudyAllSchedule()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else { return }
        
        sheetCoordinator = UBottomSheetCoordinator(parent: self, delegate: self)
        
        if dataSource != nil { sheetCoordinator.dataSource = dataSource }
        
        calendarBottomSheetVC.sheetCoordinator = sheetCoordinator
        
        sheetCoordinator.addSheet(calendarBottomSheetVC, to: self, didContainerCreate: { container in
            let frame = self.view.frame
            let rect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
            container.layer.shadowColor = UIColor.appColor(.background).cgColor
        })
        
        sheetCoordinator.setCornerRadius(10)
    }
    
    // MARK: - Actions

    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(calendarView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)
        }
    }
}

// MARK: - UBottomSheetCoordinatorDelegate

extension MainCalendarViewController: UBottomSheetCoordinatorDelegate {
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
        self.sheetCoordinator.addDropShadowIfNotExist()
    }
}
