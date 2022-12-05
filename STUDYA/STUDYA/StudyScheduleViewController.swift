//
//  StudyScheduleViewController.swift
//  STUDYA
//
//  Created by EHDDOMB on 11/22/22.
//

import UIKit

class StudyScheduleViewController: UIViewController {
    
    // MARK: - Properties
    
    let studySchedules: [Studyschedule] = [Studyschedule(), Studyschedule(), Studyschedule(), Studyschedule(), Studyschedule(), Studyschedule(), Studyschedule(), Studyschedule(), Studyschedule()]
    
    let calendarView: UICalendarView = {
        let c = UICalendarView()
        
        c.calendar = Calendar(identifier: .gregorian)
        c.tintColor = .appColor(.keyColor1)
        
        return c
    }()
    
    let scheduleTableView = ScheduleTableView()
    
    let floatingButtonView = PlusButtonWithLabelContainerView(labelText: "일정추가")
      

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
    }
    
    // MARK: - Actions
    
    @objc func floatingButtonDidTapped() {
    
        let vc = StudySchedulePriodFormViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        
        return cell
    }
}

extension StudyScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

