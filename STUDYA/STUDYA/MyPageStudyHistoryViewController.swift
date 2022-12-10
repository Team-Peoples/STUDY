//
//  MyPageStudyHistoryViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/23.
//

import UIKit

final class MyPageStudyHistoryViewController: UIViewController {
    
    internal var studyHistoryList: [StudyHistory]?
    
    private let tableView: UITableView = {
       
        let tableView = UITableView(frame: .zero)
        
        tableView.register(StudyHistoryTableViewCell.self, forCellReuseIdentifier: StudyHistoryTableViewCell.identifier)
        tableView.separatorColor = UIColor.appColor(.ppsGray3)
        tableView.rowHeight = 75
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyHistoryList = [StudyHistory(name: "토익 영단어1", start: "2022.01.01", end: "2022.03.01", auth: "어"), StudyHistory(name: "토익 영단어2", start: "2022.01.01", end: "2022.03.01", auth: "어"), StudyHistory(name: "토익 영단어3", start: "2022.01.01", end: "2022.03.01", auth: "어")]
                
        view.backgroundColor = .systemBackground
        
        title = "참여한 스터디"
        navigationController?.setBrandNavigation()
        
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

extension MyPageStudyHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studyHistoryList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyHistoryTableViewCell.identifier, for: indexPath) as? StudyHistoryTableViewCell else { return StudyHistoryTableViewCell() }
        
        cell.studyHistory = studyHistoryList?[indexPath.row]
        
        return cell
    }
    
}
