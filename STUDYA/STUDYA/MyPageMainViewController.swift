//
//  MyPageMainViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/21.
//

import UIKit

final class MyPageMainViewController: UIViewController {
    
    internal var nickName: String?
    internal var myMail: String?
    private let titles = ["참여한 스터디", "푸시알림 설정", "앱정보", "로그아웃", "회원 탈퇴"]
    private var delegate: NavigationControllerDelegate?
    
    private let profileImageSelectorView = ProfileImageSelectorView(size: 80)
    private lazy var nickNameLabel = CustomLabel(title: nickName ?? "닉네임", tintColor: .titleGeneral, size: 16, isBold: true, isNecessaryTitle: false)
    private lazy var myMailLabel = CustomLabel(title: myMail ?? "peoples.noreply@gmail.com" , tintColor: .subTitleGeneral, size: 12)
    private let tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
        tableView.rowHeight = 55
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.appColor(.background)
        title = "마이페이지"
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(profileImageSelectorView)
        view.addSubview(nickNameLabel)
        view.addSubview(myMailLabel)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        profileImageSelectorView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 35, leading: view.leadingAnchor, leadingConstant: 28)
        nickNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 50, leading: profileImageSelectorView.trailingAnchor, leadingConstant: 24)
        myMailLabel.anchor(top: nickNameLabel.bottomAnchor, topConstant: 7, leading: nickNameLabel.leadingAnchor)
        tableView.anchor(top: profileImageSelectorView.bottomAnchor, topConstant: 61, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 55 * 5)
    }
}

extension MyPageMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else { return MyPageTableViewCell() }
        
        cell.title = titles[indexPath.row]
        
        return cell
    }
}

extension MyPageMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            push(MyPageStudyHistoryViewController())
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MyPageMainViewController: NavigationControllerDelegate {
    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
