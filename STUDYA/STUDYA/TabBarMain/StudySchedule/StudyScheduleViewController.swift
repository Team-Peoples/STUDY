//
//  StudyScheduleViewController.swift
//  STUDYA
//
//  Created by EHDDOMB on 11/22/22.
//

import UIKit

class StudyScheduleViewController: SwitchableViewController {
    
    // MARK: - Properties
    
    let studyAllScheduleViewModel = StudyAllScheduleViewModel()
    
    private let studyID: ID
    private var studyScheduleAtSelectedDate = [StudySchedule]()
    private let calendarView = PeoplesCalendarView()
    private let scheduleTableView: UITableView = {
        
        let tableView = UITableView()
        
        tableView.backgroundColor = .systemBackground
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        
        tableView.register(StudyScheduleTableViewCell.self, forCellReuseIdentifier: StudyScheduleTableViewCell.identifier)
        
        return tableView
    }()
    
    lazy var selectionDelegate = UICalendarSelectionSingleDate(delegate: self)
    lazy var floatingButtonView: PlusButtonWithLabelContainerView = {
        let buttonView = PlusButtonWithLabelContainerView(labelText: "일정추가")
        
        buttonView.addTapAction(target: self, action: #selector(floatingButtonDidTapped))
        
        return buttonView
    }()
      
    // MARK: - Life Cycle
    
    init(studyID: ID) {
        self.studyID = studyID
        studyAllScheduleViewModel.getAllStudyAllSchedule()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.selectionBehavior = selectionDelegate
        
        selectionDelegate.selectedDate?.calendar = Calendar.current
        selectionDelegate.setSelected(Date().convertToDateComponents([.year, .month, .day, .hour, .minute, .weekday]), animated: true)
        
        confifureViews()
        configureTableView()
        setConstraints()
        configureNavigationBar()
        
        studyAllScheduleViewModel.bind { [self] studyAllSchedule in
            let visibleDateComponents = calendarView.visibleDateComponents
            calendarView.reloadDecorations(forDateComponents: visibleDateComponents.getAlldaysDateComponents(), animated: true)
            // domb: print를 해보면 세번정도 호출됨을 알 수 있는데 bind completion block이 너무 많이 호출되는건 아난지 나중에 고민해보기
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        studyAllScheduleViewModel.getAllStudyAllSchedule()
        
        let selectedDay = selectionDelegate.selectedDate
        guard let studySchedule = studyAllScheduleViewModel.studySchedule(of: studyID, at: selectedDay) else { fatalError() }
        studyScheduleAtSelectedDate = studySchedule
        scheduleTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    // MARK: - Actions
    
    @objc func floatingButtonDidTapped() {
        let currentStudyID = studyID
        let studySchedulePriodFormVC = CreatingStudySchedulePriodFormViewController()
        
        studySchedulePriodFormVC.studyScheduleViewModel.studySchedule.studyID = currentStudyID
        
        let navigation = UINavigationController(rootViewController: studySchedulePriodFormVC)
        
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
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
        if let studyScheduleIsEmpty = studyAllScheduleViewModel.studySchedule(of: studyID, at: dateComponents)?.isEmpty, !studyScheduleIsEmpty {
            return .image(UIImage(systemName: "circle.fill")?.resize(newWidth: 8).withRenderingMode(.alwaysTemplate), color: .appColor(.keyColor1))
        } else {
            return nil
        }
    }
}
extension StudyScheduleViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let studySchedule = studyAllScheduleViewModel.studySchedule(of: studyID, at: dateComponents) else { return }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyScheduleTableViewCell.identifier, for: indexPath) as? StudyScheduleTableViewCell else { return UITableViewCell() }
        
        let schedule = studyScheduleAtSelectedDate[indexPath.row]
        
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
          
            let editingStudyScheduleVC = EditingStudySchduleViewController(studySchedule: studyScheduleAtSelectedDate[indexPath.row])
            
            let navigationVC = UINavigationController(rootViewController: editingStudyScheduleVC)
            navigationVC.modalPresentationStyle = .fullScreen
            
            present(navigationVC, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            
            let popupVC = StudySchedulePopUpAlertViewController(type: "삭제")
            popupVC.firstButtonAction = { [self] in
                studyAllScheduleViewModel.deleteStudySchedule(id: studyScheduleAtSelectedDate[indexPath.row].studyScheduleID!, deleteRepeatedSchedule: false) { [self] in
                    studyAllScheduleViewModel.getAllStudyAllSchedule()
                    
                    guard let studySchedule = studyAllScheduleViewModel.studySchedule(of: studyID, at: selectionDelegate.selectedDate) else { return }
                    studyScheduleAtSelectedDate = studySchedule
                    scheduleTableView.reloadData()
                    
                    dismiss(animated: true)
                }
            }
            popupVC.secondButtonAction = { [self] in
                studyAllScheduleViewModel.deleteStudySchedule(id: studyScheduleAtSelectedDate[indexPath.row].studyScheduleID!, deleteRepeatedSchedule: true) {
                    self.studyAllScheduleViewModel.getAllStudyAllSchedule()
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

