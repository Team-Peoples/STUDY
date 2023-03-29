//
//  MainCalendarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import UIKit

final class MainCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    private let studyAllScheduleViewModel = StudyScheduleViewModel()
    private var selectedDate: Date = Date()
    private var studyAllSchedule: [StudySchedule] = []
    var sheetCoordinator: UBottomSheetCoordinator!
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    private let calendarView = CustomCalendarView()
    let calendarBottomSheetViewController = MainCalendarBottomSheetViewController()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "나의 캘린더"
        
        // 스터디 스케쥴 바인딩
        studyAllScheduleViewModel.bind { [self] allStudyScheduleOfAllStudy in
            
            let studySchedule = allStudyScheduleOfAllStudy.mappingStudyScheduleArray()
            studyAllSchedule = studySchedule
            
            // domb: 캘린더에 스터디 스케쥴과 관련된 정보를 넣을수밖에 없나...
            calendarView.bind(studySchedule)
            calendarBottomSheetViewController.studyScheduleAtSelectedDate = studyAllSchedule.filteredStudySchedule(at: selectedDate)
        }
        
        studyAllScheduleViewModel.getAllStudyScheduleOfAllStudy()
        
        NotificationCenter.default.addObserver(forName: .updateStudySchedule, object: nil, queue: nil) { [self] _ in
            studyAllScheduleViewModel.getAllStudyScheduleOfAllStudy()
            calendarView.reloadData()
        }
        
        calendarView.delegate = self
        calendarView.select(date: selectedDate)
        
        dataSource = CalendarBottomSheetDatasource()
        
        configureViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else { return }
        
        sheetCoordinator = UBottomSheetCoordinator(parent: self, delegate: self)
        
        if dataSource != nil { sheetCoordinator.dataSource = dataSource }
        
        calendarBottomSheetViewController.sheetCoordinator = sheetCoordinator
        
        sheetCoordinator.addSheet(calendarBottomSheetViewController, to: self, didContainerCreate: { container in
            let frame = self.view.frame
            let rect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
            container.layer.shadowColor = UIColor.appColor(.background).cgColor
        })
        
        sheetCoordinator.setCornerRadius(10)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions

    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .white
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
    
    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
        switch state {
        case .finished( _, let percentage):
            NotificationCenter.default.post(name: .bottomSheetSizeChanged, object: nil, userInfo:["percentage": percentage])
        default:
            return
        }
    }
}

extension MainCalendarViewController: CustomCalendarViewDelegate {
   
    func calendarView(didselectAt date: Date) {
        selectedDate = date
        calendarBottomSheetViewController.studyScheduleAtSelectedDate = studyAllSchedule.filteredStudySchedule(at: selectedDate)
        NotificationCenter.default.post(name: .mainCalenderDateTapped, object: date)
    }
}
