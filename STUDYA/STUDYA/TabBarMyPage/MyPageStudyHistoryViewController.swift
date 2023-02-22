//
//  MyPageStudyHistoryViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/23.
//

import UIKit

final class MyPageStudyHistoryViewController: UIViewController {
    
    private var studyListIParticipatedIn: [Study] = []
    private let tableView: UITableView = {
       
        let tableView = UITableView(frame: .zero)
        
        tableView.register(StudyHistoryTableViewCell.self, forCellReuseIdentifier: StudyHistoryTableViewCell.identifier)
        tableView.separatorColor = UIColor.appColor(.ppsGray3)
        tableView.rowHeight = 75
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudyIParticipatedIn { studyList in
            self.studyListIParticipatedIn = studyList
        }
        
        view.backgroundColor = .systemBackground
        
        title = "참여한 스터디"
        navigationController?.setBrandNavigation()
        
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func getStudyIParticipatedIn(_ successHandler: @escaping ([Study]) -> Void) {
        Network.shared.getStudyIParticipatedIn { result in
            switch result {
            case .success(let StudyParticipatedIn):
                successHandler(StudyParticipatedIn)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MyPageStudyHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studyListIParticipatedIn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyHistoryTableViewCell.identifier, for: indexPath) as? StudyHistoryTableViewCell else { return StudyHistoryTableViewCell() }
        
        cell.studyIParticipatedIn = studyListIParticipatedIn[indexPath.row]
        
        return cell
    }
    
}
