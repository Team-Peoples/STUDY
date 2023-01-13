//
//  StudyScheduleViewController.swift
//  STUDYA
//
//  Created by EHDDOMB on 11/22/22.
//

import UIKit

class StudyScheduleViewController: SwitchableViewController {
    
    // MARK: - Properties
    
    let studyID: ID
    
    var studyAllScheduleViewModel = StudyAllScheduleViewModel()
    
    var studyScheduleAtSelectedDate = [StudySchedule]()
    
    lazy var calendarView = PeoplesCalendarView()
    
    let scheduleTableView = ScheduleTableView()
    
    lazy var floatingButtonView: PlusButtonWithLabelContainerView = {
        let buttonView = PlusButtonWithLabelContainerView(labelText: "일정추가")
        
        buttonView.addTapAction(target: self, action: #selector(floatingButtonDidTapped))
        
        return buttonView
    }()
      

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
        
        let selectionDelegate = UICalendarSelectionSingleDate(delegate: self)
        selectionDelegate.selectedDate?.calendar = Calendar.current
        selectionDelegate.setSelected(Date().convertToDateComponents(), animated: false)
        
        calendarView.delegate = self
        calendarView.selectionBehavior = selectionDelegate
        
        confifureViews()
        configureTableView()
        setConstraints()
        configureNavigationBar()
        
        //domb: 스터디 시간과 날짜 분리해서 작성
        
        studyAllScheduleViewModel.bind { [self] studyAllSchedule in
            let dateComponents = studyAllSchedule["\(studyID)"]?.compactMap({ studySchedule in
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: studySchedule.startDate!)
                return dateComponents
            })
            
            guard let dateComponents = dateComponents else { return }
            let overlapRemovedDateComponents = Array(Set(dateComponents))

            calendarView.reloadDecorations(forDateComponents: overlapRemovedDateComponents, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        studyAllScheduleViewModel.getStudyAllSchedule { [self] in
            guard let studySchedule = studyAllScheduleViewModel.studySchedules(of: studyID, at: Date().convertToDateComponents()) else { fatalError() }
            self.studyScheduleAtSelectedDate = studySchedule
            self.scheduleTableView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    // MARK: - Actions
    
    @objc func floatingButtonDidTapped() {
        let currentStudyID = studyID
        let studySchedulePriodFormVC = CreatingStudySchedulePriodFormViewController()
        
        studySchedulePriodFormVC.studyScheduleViewModel.studySchedule.studyId = currentStudyID
        
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
    
    private func confifureViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(calendarView)
        view.addSubview(scheduleTableView)
        view.addSubview(floatingButtonView)
    }
    
    private func configureTableView() {
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        scheduleTableView.backgroundColor = .appColor(.background)
        
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(500)
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

// MARK: - UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate

extension StudyScheduleViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let studyScheduleIsEmpty = studyAllScheduleViewModel.studySchedules(of: studyID, at: dateComponents)?.isEmpty, !studyScheduleIsEmpty {
            return .image(UIImage(systemName: "circle.fill")?.resize(newWidth: 8).withRenderingMode(.alwaysTemplate), color: .appColor(.keyColor1))
        } else {
            return nil
        }
    }
}
extension StudyScheduleViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let studySchedule = studyAllScheduleViewModel.studySchedules(of: studyID, at: dateComponents) else { return }
        
        self.studyScheduleAtSelectedDate = studySchedule
        self.scheduleTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension StudyScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studyScheduleAtSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell() }
        
        let schedule = studyScheduleAtSelectedDate[indexPath.row]
        
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
//            editingStudyScheduleVC.studySchedule = studySchedules[indexPath.row]
            
            let navigationVC = UINavigationController(rootViewController: editingStudyScheduleVC)
            navigationVC.modalPresentationStyle = .fullScreen
            
            present(navigationVC, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            
            let alertController = UIAlertController(title: "이일정을 삭제 할까요?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "삭제", style: .destructive) {
                _ in

//                self.studySchedules.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "닫기", style: .cancel)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: Const.cancel, style: .cancel)

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

