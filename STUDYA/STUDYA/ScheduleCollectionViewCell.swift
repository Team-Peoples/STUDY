//
//  MyScheduleCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/19.
//

import UIKit

/// dummy data
struct Studyschedule {
    let color = UIColor.orange
    let studyName = "개발스터디"
    let studyPlace = "강남구"
    let studySubject = "HIG 톺아보기"
    let studyScheduleTime = "00:00 am - 00:00 pm"
}

class ScheduleCollectionViewCell: UICollectionViewCell {
    
    let studySchedules: [Studyschedule] = [Studyschedule(),Studyschedule(),Studyschedule()]
    
    private let scheduleTableView = ScheduleTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scheduleTableView.dataSource = self
        scheduleTableView.rowHeight = 120
        
        self.contentView.addSubview(scheduleTableView)
        scheduleTableView.backgroundColor = .appColor(.background)
        
        scheduleTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ScheduleCollectionViewCell: UITableViewDataSource {
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
