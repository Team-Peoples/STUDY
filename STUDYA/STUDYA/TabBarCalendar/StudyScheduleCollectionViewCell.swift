//
//  StudyScheduleCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/19.
//

import UIKit

class StudyScheduleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "StudyScheduleCollectionViewCell"
    
    var studySchedules: [StudyScheduleComing] = []
    
    lazy var studyScheduleEmptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "일정이 없어요 😴"
        return lbl
    }()
    
    private let scheduleTableView: UITableView = {
        
        let tableView = UITableView()
        
        tableView.backgroundColor = .systemBackground
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        
        tableView.register(StudyScheduleTableViewCell.self, forCellReuseIdentifier: StudyScheduleTableViewCell.identifier)
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        
        self.contentView.addSubview(scheduleTableView)
        scheduleTableView.backgroundColor = .appColor(.background)
        
        scheduleTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func reloadTableView() {
       
        scheduleTableView.reloadData()
    }
    
    func checkScheduleIsEmpty() {

        if studySchedules.isEmpty {
            scheduleTableView.addSubview(studyScheduleEmptyLabel)
            studyScheduleEmptyLabel.snp.makeConstraints { make in
                make.centerX.equalTo(scheduleTableView)
                make.top.equalTo(scheduleTableView).inset(100)
            }
        } else {
            studyScheduleEmptyLabel.removeFromSuperview()
        }
    }
}

extension StudyScheduleCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studySchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudyScheduleTableViewCell.identifier, for: indexPath) as! StudyScheduleTableViewCell
        
        let schedule = studySchedules[indexPath.row]
        
        cell.configure(schedule: schedule, kind: .personal)
        
        return cell
    }
}

extension StudyScheduleCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
