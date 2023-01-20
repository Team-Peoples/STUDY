//
//  MainCalendarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import UIKit

@available(iOS 16.0, *)

final class MainCalendarViewController: UIViewController, ScheduleCoordinator {
    
    // MARK: - Properties
    
    let studyAllScheduleViewModel = StudyAllScheduleViewModel()
    
    var sheetCoordinator: UBottomSheetCoordinator!
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    let calendarView = PeoplesCalendarView()
    let calendarBottomSheetVC = CalendarBottomSheetViewController()
    lazy var selectionDelegate = UICalendarSelectionSingleDate(delegate: self)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studyAllScheduleViewModel.getStudyAllSchedule()
        
        calendarView.delegate = self
        calendarView.selectionBehavior = selectionDelegate
        
        selectionDelegate.selectedDate?.calendar = Calendar.current
        selectionDelegate.setSelected(Date().convertToDateComponents([.year, .month, .day, .hour, .minute, .weekday]), animated: true)
        
        studyAllScheduleViewModel.bind { [self] studyAllSchedule in
            let visibleDateComponents = calendarView.visibleDateComponents
            calendarView.reloadDecorations(forDateComponents: visibleDateComponents.getAlldaysDateComponents(), animated: true)
        }
        
        dataSource = CalendarBottomSheetDatasource()
        title = "나의 캘린더"
        
        configureViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        studyAllScheduleViewModel.getStudyAllSchedule { [self] in
            let selectedDay = selectionDelegate.selectedDate
            let studySchedule = studyAllScheduleViewModel.studySchedule(at: selectedDay)
            calendarBottomSheetVC.studySchedule = studySchedule
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else { return }
        
        sheetCoordinator = UBottomSheetCoordinator(parent: self, delegate: self)
        
        if dataSource != nil { sheetCoordinator.dataSource = dataSource }
        
        calendarBottomSheetVC.sheetCoordinator = sheetCoordinator
        calendarBottomSheetVC.scheduleCoordinator = self
        
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

// MARK: - UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate

extension MainCalendarViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        if !studyAllScheduleViewModel.studySchedule(at: dateComponents).isEmpty {
            return .image(UIImage(systemName: "circle.fill")?.resize(newWidth: 8).withRenderingMode(.alwaysTemplate), color: .appColor(.keyColor1))
        } else {
            return nil
        }
    }
}

extension MainCalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        NotificationCenter.default.post(name: .mainCalenderDateTapped, object: dateComponents)
        let studySchedule = studyAllScheduleViewModel.studySchedule(at: dateComponents)
        calendarBottomSheetVC.studySchedule = studySchedule
    }
}
