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
            studyScheduleOfThisStudyAtSelectedDate = studyScheduleOfThisStudy.filteredStudySchedule(at: selectedDate)
        }
    }
    
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
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
        
        studyAllScheduleViewModel.bind { [self] allStudyScheduleOfAllStudy in
            calendarView.select(date: selectedDate)
            
            let studySchedule = allStudyScheduleOfAllStudy.mappingStudyScheduleArray()
            let studyScheduleThisStudy = studySchedule.filteredStudySchedule(by: studyID)
            
            calendarView.bind(studyScheduleThisStudy)
            calendarView.reloadData()
            
            studyScheduleOfThisStudy = studyScheduleThisStudy
        }
        
        studyAllScheduleViewModel.getAllStudyScheduleOfAllStudy()
        
        confifureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc func floatingButtonDidTapped() {
        
        let currentStudyID = studyID
        let studySchedulePriodFormVC = CreatingStudySchedulePriodFormViewController()
        let dashedSelectedDate = DateFormatter.dashedDateFormatter.string(from: selectedDate)
        
        studySchedulePriodFormVC.studySchedulePostingViewModel.studySchedule.studyID = currentStudyID
        studySchedulePriodFormVC.studySchedulePostingViewModel.studySchedule.startDate = dashedSelectedDate
        
        let navigation = UINavigationController(rootViewController: studySchedulePriodFormVC)
        
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    private func addNotification(){
        NotificationCenter.default.addObserver(forName: .updateStudySchedule, object: nil, queue: nil) { [self] _ in
            studyAllScheduleViewModel.getAllStudyScheduleOfAllStudy()
        }
    }
    
    override func extraWorkWhenSwitchToggled() {
        floatingButtonView.isHidden = !isSwitchOn
        
        let cells = scheduleTableView.cellsForRows(at: 0)
        let scheduleTableViewCells = cells.compactMap { cell in
            let cell = cell as? StudyScheduleTableViewCell
            return cell
        }
        
        scheduleTableViewCells.forEach { cell in
            cell.editable = isSwitchOn
        }
    }
    
    // MARK: - Configure
    
    private func confifureViews() {
        
        view.backgroundColor = .systemBackground
        
        tabBarController?.tabBar.isHidden = true
        
        floatingButtonView.addTapAction(target: self, action: #selector(floatingButtonDidTapped))
        
        addNotification()
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
        scheduleTableView.backgroundColor = studyScheduleOfThisStudyAtSelectedDate.count == 0 ? .systemBackground:.appColor(.background)
        
        return studyScheduleOfThisStudyAtSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyScheduleTableViewCell.identifier, for: indexPath) as? StudyScheduleTableViewCell else { return UITableViewCell() }
        
        let schedule = studyScheduleOfThisStudyAtSelectedDate[indexPath.row]
        
        cell.configure(schedule: schedule, kind: .study)
        cell.editable = self.isSwitchOn
        
        cell.etcButtonAction = { [unowned self] in
            presentActionSheet(selected: cell, indexPath: indexPath, in: tableView)
        }
        
        return cell
    }
    
    func presentActionSheet(selected cell: StudyScheduleTableViewCell, indexPath: IndexPath, in tableView: UITableView) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [unowned self] _ in
            
            let editingStudyScheduleVC = EditingStudySchduleViewController(studySchedule: studyScheduleOfThisStudyAtSelectedDate[indexPath.row])
            
            let navigationVC = UINavigationController(rootViewController: editingStudyScheduleVC)
            navigationVC.modalPresentationStyle = .fullScreen
            
            present(navigationVC, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            
            let popupVC = StudySchedulePopUpAlertViewController(type: Constant.delete)
            popupVC.firstButtonAction = { [self] in
                studyAllScheduleViewModel.deleteStudySchedule(id: studyScheduleOfThisStudyAtSelectedDate[indexPath.row].studyScheduleID!, deleteRepeatedSchedule: false) { [self] in
                    // domb: 이부분도 노티로 처리하는게 좋을 것 같음.
                    studyAllScheduleViewModel.getAllStudyScheduleOfAllStudy()
                    
                    scheduleTableView.reloadData()
                    
                    dismiss(animated: true)
                }
            }
            popupVC.secondButtonAction = { [self] in
                studyAllScheduleViewModel.deleteStudySchedule(id: studyScheduleOfThisStudyAtSelectedDate[indexPath.row].studyScheduleID!, deleteRepeatedSchedule: true) {
                    self.studyAllScheduleViewModel.getAllStudyScheduleOfAllStudy()
                    self.dismiss(animated: true)
                    self.scheduleTableView.reloadData()
                }
            }
            
            self.present(popupVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
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
        studyScheduleOfThisStudyAtSelectedDate = studyScheduleOfThisStudy.filteredStudySchedule(at: selectedDate)
    }
}

