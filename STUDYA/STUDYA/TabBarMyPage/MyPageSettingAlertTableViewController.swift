//
//  SettingAlertTableViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/24.
//

import UIKit

final class MyPageSettingAlertTableViewController: UIViewController {
    
    private let data = ["출석체크 시작 알림", "스터디 일정 임박 알림", "스터디 일정 예정 알림"]
    
    private let titleLabel = CustomLabel(title: "스터디 시간 알림", tintColor: .ppsBlack, size: 16, isBold: true, isNecessaryTitle: false)
    private let tableView: UITableView = {
       
        let tableView = UITableView(frame: .zero)
        
        tableView.register(SettingAlertTableViewCell.self, forCellReuseIdentifier: SettingAlertTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.appColor(.background)
        
        title = "푸시알림 설정"
        navigationController?.setupNavigationBarBackButtonDisplayMode()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 12, leading: view.leadingAnchor, leadingConstant: 20)
        tableView.anchor(top: titleLabel.bottomAnchor, topConstant: 12, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

extension MyPageSettingAlertTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingAlertTableViewCell.identifier, for: indexPath) as? SettingAlertTableViewCell else { return SettingAlertTableViewCell() }
        
        cell.titleText = data[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
