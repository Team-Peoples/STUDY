//
//  StudyScheduleViewController.swift
//  STUDYA
//
//  Created by EHDDOMB on 11/22/22.
//

import UIKit

class StudyScheduleViewController: SwitchableViewController {
    
    // MARK: - Properties
    
    var studySchedules: [StudySchedule] = [
        StudySchedule(openDate: Date(), deadlineDate: Date(), startTime: Date(), endTime: Date(), repeatOption: RepeatOption.everyDay, topic: "HIG 높아보기", place: "강남구"),
        StudySchedule(openDate: Date(), deadlineDate: Date(), startTime: Date(), endTime: Date(), repeatOption: RepeatOption.everyDay, topic: "HIG 높아보기", place: "강남구"),
        StudySchedule(openDate: Date(), deadlineDate: Date(), startTime: Date(), endTime: Date(), repeatOption: RepeatOption.everyDay, topic: "HIG 높아보기", place: "강남구"),
        StudySchedule(openDate: Date(), deadlineDate: Date(), startTime: Date(), endTime: Date(), repeatOption: RepeatOption.everyDay, topic: "HIG 높아보기", place: "강남구"),
        StudySchedule(openDate: Date(), deadlineDate: Date(), startTime: Date(), endTime: Date(), repeatOption: RepeatOption.everyDay, topic: "HIG 높아보기", place: "강남구"),
        StudySchedule(openDate: Date(), deadlineDate: Date(), startTime: Date(), endTime: Date(), repeatOption: RepeatOption.everyDay, topic: "HIG 높아보기", place: "강남구")
    ]
    
    let calendarView: UICalendarView = {
        let c = UICalendarView()
        
        c.calendar = Calendar(identifier: .gregorian)
        c.tintColor = .appColor(.keyColor1)
        
        return c
    }()
    
    let scheduleTableView = ScheduleTableView()
    
    lazy var floatingButtonView = PlusButtonWithLabelContainerView(labelText: "일정추가")
      

    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(calendarView)
        view.addSubview(scheduleTableView)
        view.addSubview(floatingButtonView)
        
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        scheduleTableView.backgroundColor = .appColor(.background)
        
        tabBarController?.tabBar.isHidden = true
        
        floatingButtonView.addTapAction(target: self, action: #selector(floatingButtonDidTapped))
        
        setConstraints()
        
        configureNavigationBar()
    }
    
    // MARK: - Actions
    
    @objc func floatingButtonDidTapped() {
        
        let studySchedulePriodFormVC = CreatingStudySchedulePriodFormViewController()
        
        let navigation = UINavigationController(rootViewController: studySchedulePriodFormVC)
        
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    override func extraWorkWhenSwitchToggled() {
        floatingButtonView.isHidden = !isSwitchOn
        let cells = scheduleTableView.cellsForRows(at: 0)
        let scheduleTableViewCells = cells.compactMap { cell in
            let cell = cell as? ScheduleTableViewCell
            return cell
        }
        scheduleTableViewCells.forEach { cell in
            cell.editable = isSwitchOn
        }
    }
    
    // MARK: - Configure

    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)
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

extension StudyScheduleViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return.default()
    }
}
extension StudyScheduleViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
    }
}

extension StudyScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studySchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell() }
        
        let schedule = studySchedules[indexPath.row]
        
        cell.configure(schedule: schedule, kind: .study)
        cell.editable = self.isSwitchOn
        
        cell.etcButtonAction = { [unowned self] in
            presentActionSheet(selected: cell, indexPath: indexPath, in: tableView)
        }
        
        return cell
    }
    
    func presentActionSheet(selected cell: ScheduleTableViewCell, indexPath: IndexPath, in tableView: UITableView) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [unowned self] _ in
          
            let editingStudyScheduleVC = EditingStudySchduleViewController()
            editingStudyScheduleVC.studySchedule = studySchedules[indexPath.row]
            
            let navigationVC = UINavigationController(rootViewController: editingStudyScheduleVC)
            navigationVC.modalPresentationStyle = .fullScreen
            
            present(navigationVC, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            
            let alertController = UIAlertController(title: "이일정을 삭제 할까요?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "삭제", style: .destructive) {
                _ in

                self.studySchedules.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "닫기", style: .cancel)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

extension StudyScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

