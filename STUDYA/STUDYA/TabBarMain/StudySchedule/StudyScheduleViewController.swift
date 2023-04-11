//
//  StudyScheduleViewController.swift
//  STUDYA
//
//  Created by EHDDOMB on 11/22/22.
//

import UIKit
import FSCalendar

class StudyScheduleViewController: SwitchableViewController {
    
    // MARK: - Properties
    
    let studyAllScheduleViewModel = StudyScheduleViewModel()
    
    private let studyID: ID
    private var selectedDate: Date = Date()
    private var studyScheduleOfThisStudy: [StudySchedule] = [] {
        didSet {
            studyScheduleOfThisStudyAtSelectedDate = studyScheduleOfThisStudy.filteredStudySchedule(at: selectedDate).sorted(by: {$0.startDateAndTime < $1.startDateAndTime})
            
            var studyScheduleTimeTable = [DashedDate: [TimeRange]]()
            studyScheduleOfThisStudy.forEach { studySchedule in
                let studyScheduleStartDay = studySchedule.startDateAndTime
                let startDate = DateFormatter.dashedDateFormatter.string(from: studyScheduleStartDay)
                let startTime = DateFormatter.timeFormatter.string(from: studyScheduleStartDay)
                let endTime = DateFormatter.timeFormatter.string(from: studySchedule.endDateAndTime)
                if studyScheduleTimeTable[startDate] == nil {
                    studyScheduleTimeTable[startDate] = [(StartTime: startTime, EndTime: endTime)]
                } else {
                    studyScheduleTimeTable[startDate]?.append((StartTime: startTime, EndTime: endTime))
                }
            }
            self.studyScheduleTimeTableList = studyScheduleTimeTable
        }
    }
    private var studyScheduleTimeTableList: [DashedDate: [TimeRange]]?
    private var studyScheduleOfThisStudyAtSelectedDate: [StudySchedule] = [] {
        didSet {
            scheduleTableView.reloadData()
        }
    }
    private let calendarView = CustomCalendarView()
    private let scheduleTableView: UITableView = {
        
        let tableView = UITableView()
    
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        
        tableView.register(StudyScheduleTableViewCell.self, forCellReuseIdentifier: StudyScheduleTableViewCell.identifier)
        
        return tableView
    }()
    lazy var floatingButtonView = PlusButtonWithLabelContainerView(labelText: "일정추가")
        
    
    // MARK: - Life Cycle
    
    init(studyID: ID) {
        self.studyID = studyID
        print(#function)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        
        studyAllScheduleViewModel.bind { [weak self] allStudyScheduleOfAllStudy in
            guard !allStudyScheduleOfAllStudy.isEmpty else { return }
            
            self?.calendarView.select(date: self?.selectedDate)
            
            let studySchedule = allStudyScheduleOfAllStudy.mappingStudyScheduleForIncludingStudyID()
            let studyScheduleThisStudy = studySchedule.filterStudySchedule(by: self?.studyID)
            
            self?.calendarView.bind(studyScheduleThisStudy)
            self?.calendarView.reloadData()
            
            self?.studyScheduleOfThisStudy = studyScheduleThisStudy
        }
        
        studyAllScheduleViewModel.getAllStudyScheduleOfAllStudy()
        
        confifureViews()
    }
    
    // MARK: - Actions
    
    @objc func floatingButtonDidTapped() {
        
        let currentStudyID = studyID
        let studySchedulePriodFormVC = CreatingStudySchedulePriodFormViewController()
        let dashedSelectedDate = DateFormatter.dashedDateFormatter.string(from: selectedDate)
        
        studySchedulePriodFormVC.existingStudyScheduleTimeTable = studyScheduleTimeTableList
        studySchedulePriodFormVC.studySchedulePostingViewModel.studySchedule.studyID = currentStudyID
        studySchedulePriodFormVC.studySchedulePostingViewModel.studySchedule.startDate = dashedSelectedDate
        
        let navigation = UINavigationController(rootViewController: studySchedulePriodFormVC)
        
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    override func extraWorkWhenSwitchToggled(isOn: Bool) {
        floatingButtonView.isHidden = !isOn
        
        let cells = scheduleTableView.cellsForRows(at: 0)
        let scheduleTableViewCells = cells.compactMap { cell in
            let cell = cell as? StudyScheduleTableViewCell
            return cell
        }
        
        scheduleTableViewCells.forEach { cell in
            cell.editable = isOn
        }
    }
    
    // MARK: - Configure
    
    private func confifureViews() {
        
        view.backgroundColor = .white
        
        tabBarController?.tabBar.isHidden = true
        
        floatingButtonView.addTapAction(target: self, action: #selector(floatingButtonDidTapped))
        
        NotificationCenter.default.addObserver(forName: .updateStudySchedule, object: nil, queue: nil) { [weak self] _ in
            self?.studyAllScheduleViewModel.getAllStudyScheduleOfAllStudy()
        }
        
        configureTableView()
        addSubViewsWithConstraints()
        
    }
    
    private func configureTableView() {
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    private func addSubViewsWithConstraints() {
        
        view.addSubview(calendarView)
        view.addSubview(scheduleTableView)
        view.addSubview(floatingButtonView)
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
        
        scheduleTableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        floatingButtonView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.width.equalTo(102)
            make.height.equalTo(50)
        }
    }
}

// MARK: - UITableViewDataSource

extension StudyScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scheduleTableView.backgroundColor = studyScheduleOfThisStudyAtSelectedDate.count == 0 ? .white:.appColor(.background)
        
        return studyScheduleOfThisStudyAtSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyScheduleTableViewCell.identifier, for: indexPath) as? StudyScheduleTableViewCell else { return UITableViewCell() }
        
        let schedule = studyScheduleOfThisStudyAtSelectedDate[indexPath.row]
        
        cell.configure(schedule: schedule, kind: .study)
        cell.editable = UserDefaults.standard.bool(forKey: Constant.isSwitchOn)
        
        cell.etcButtonAction = { [unowned self] in
            presentActionSheet(selected: cell, indexPath: indexPath, in: tableView)
        }
        
        return cell
    }
    
    func presentActionSheet(selected cell: StudyScheduleTableViewCell, indexPath: IndexPath, in tableView: UITableView) {
        
        let studySchedule = studyScheduleOfThisStudyAtSelectedDate[indexPath.row]
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
            // 반복인지 확인하고 분기처리
            
            guard let repeatOption = studySchedule.repeatOption, repeatOption != .norepeat else {
                
                let popupVC = StudySchedulePopUpAlertViewController(type: Constant.edit, repeatOption: .norepeat)
                
                popupVC.firstButtonAction = {
                    self?.dismiss(animated: true)
                    
                    let editingStudyScheduleVC = EditingStudySchduleViewController(studySchedule: studySchedule, isUpdateRepeatDay: false)
                    editingStudyScheduleVC.existingStudyScheduleTimeTable = self?.studyScheduleTimeTableList
                    let navigationVC = UINavigationController(rootViewController: editingStudyScheduleVC)
                    navigationVC.modalPresentationStyle = .fullScreen
                    
                    self?.present(navigationVC, animated: true)
                }
                
                self?.present(popupVC, animated: true)
                return
            }
            
            let popupVC = StudySchedulePopUpAlertViewController(type: Constant.edit, repeatOption: repeatOption)
            
            popupVC.firstButtonAction = {
                self?.dismiss(animated: true)
                
                let editingStudyScheduleVC = EditingStudySchduleViewController(studySchedule: studySchedule, isUpdateRepeatDay: false)
                editingStudyScheduleVC.existingStudyScheduleTimeTable = self?.studyScheduleTimeTableList
                
                let navigationVC = UINavigationController(rootViewController: editingStudyScheduleVC)
                navigationVC.modalPresentationStyle = .fullScreen
                
                self?.present(navigationVC, animated: true)
            }
            popupVC.secondButtonAction = {
                self?.dismiss(animated: true)
                
                let editingStudyScheduleVC = EditingStudySchduleViewController(studySchedule: studySchedule, isUpdateRepeatDay: true)
                editingStudyScheduleVC.existingStudyScheduleTimeTable = self?.studyScheduleTimeTableList
                
                let navigationVC = UINavigationController(rootViewController: editingStudyScheduleVC)
                navigationVC.modalPresentationStyle = .fullScreen
                
                self?.present(navigationVC, animated: true)
            }
            
            self?.present(popupVC, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            
            guard let repeatOption = studySchedule.repeatOption,
                  repeatOption != .norepeat else {
                let popupVC = StudySchedulePopUpAlertViewController(type: Constant.delete, repeatOption: .norepeat)
                popupVC.firstButtonAction = {
                    self?.studyAllScheduleViewModel.deleteStudySchedule(id: studySchedule.studyScheduleID!, deleteRepeatedSchedule: false) {
                       
                        NotificationCenter.default.post(name: .updateStudySchedule, object: nil)
                        self?.dismiss(animated: true)
                    }
                }
                
                self?.present(popupVC, animated: true)
                return
            }
            
            let popupVC = StudySchedulePopUpAlertViewController(type: Constant.delete, repeatOption: repeatOption)
            popupVC.firstButtonAction = {
                self?.studyAllScheduleViewModel.deleteStudySchedule(id: studySchedule.studyScheduleID!, deleteRepeatedSchedule: false) {
                    
                    NotificationCenter.default.post(name: .updateStudySchedule, object: nil)
                    self?.dismiss(animated: true)
                }
            }
            popupVC.secondButtonAction = {
                self?.studyAllScheduleViewModel.deleteStudySchedule(id: studySchedule.studyScheduleID!, deleteRepeatedSchedule: true) {

                    NotificationCenter.default.post(name: .updateStudySchedule, object: nil)
                    self?.dismiss(animated: true)
                }
            }

            self?.present(popupVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(actionSheet, animated: true, completion: nil)
            }
        } else {
          self.present(actionSheet, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate

extension StudyScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension StudyScheduleViewController: CustomCalendarViewDelegate {
    func calendarView(didselectAt date: Date) {
        selectedDate = date
        studyScheduleOfThisStudyAtSelectedDate = studyScheduleOfThisStudy.filteredStudySchedule(at: selectedDate).sorted(by: {$0.startDateAndTime < $1.startDateAndTime})
    }
}

