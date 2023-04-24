//
//  MyPageStudyHistoryViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/23.
//

import UIKit

final class MyPageStudyHistoryViewController: UIViewController {
    
    internal var studyHistoryList: ParticipatedStudyInfoList? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
       
        let tableView = UITableView(frame: .zero)
        
        tableView.register(StudyHistoryTableViewCell.self, forCellReuseIdentifier: StudyHistoryTableViewCell.identifier)
        tableView.separatorColor = UIColor.appColor(.ppsGray3)
        tableView.rowHeight = 75
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Network.shared.fetchParticipatedStudiesInfo() { result in
            switch result {
            case .success(let studyList):
                self.studyHistoryList = studyList
            case .failure(let failure):
                print(failure)
            }
        }
                
        view.backgroundColor = .white
        
        title = "참여한 스터디"
        navigationController?.setupBrandNavigation()
        
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

extension MyPageStudyHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studyHistoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyHistoryTableViewCell.identifier, for: indexPath) as? StudyHistoryTableViewCell else { return StudyHistoryTableViewCell() }
        
        cell.studyHistory = studyHistoryList?[indexPath.row]
        
        return cell
    }
    
}
