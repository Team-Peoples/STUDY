//
//  StudyScheduleBottomSheetController.swift
//  STUDYA
//
//  Created by 서동운 on 11/25/22.
//

import UIKit

class StudyScheduleBottomSheetController: UIViewController {
    
    // MARK: - Properties
  
    let studySchedules: [Studyschedule] = [Studyschedule(), Studyschedule(), Studyschedule()]
    
    let scheduleTableView = ScheduleTableView()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(scheduleTableView)
        
        scheduleTableView.dataSource = self
        scheduleTableView.rowHeight = 120
       
        scheduleTableView.backgroundColor = .appColor(.background)
        
        scheduleTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Actions
    // MARK: - Configure
    // MARK: - Setting Constraints
}

// MARK: - UITableViewDataSource
extension StudyScheduleBottomSheetController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studySchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        
        let studySchedule = studySchedules[indexPath.row]
        
        cell.configure(color: studySchedule.color, name: studySchedule.studyName, place: studySchedule.studyPlace, subtitle: studySchedule.studySubject, time: studySchedule.studyScheduleTime)
        
        return cell
    }
}
