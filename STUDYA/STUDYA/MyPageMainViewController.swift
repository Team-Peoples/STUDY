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
    private let titles = ["참여한 스터디", "푸시알림 설정", "앱 정보"]
    
    private let headerView: UIView = {
       
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        
        return view
    }()
    private let profileImageSelectorView = ProfileImageSelectorView(size: 80)
    private lazy var nickNameLabel = CustomLabel(title: nickName ?? "닉네임", tintColor: .ppsBlack, size: 16, isBold: true, isNecessaryTitle: false)
    private lazy var myMailLabel = CustomLabel(title: myMail ?? "peoples.noreply@gmail.com" , tintColor: .ppsGray1, size: 12)
    private let settingImageView = UIImageView(image: UIImage(named: "setting"))
    private let separatorView: RoundableView = {
       
        let view = RoundableView()
        view.backgroundColor = UIColor.appColor(.ppsGray3)
        
        return view
    }()
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
        
        giveShadow()
        settingImageView.isUserInteractionEnabled = true
        settingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingViewTapped)))
        
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setConstraints()
    }
    
    @objc private func settingViewTapped() {
        
        let nextVC = AccountManagementViewController()
        nextVC.email = "sem789456@gmail.com"
        nextVC.nickName = "사람개발자살려"
        nextVC.sns = .naver
        nextVC.modalPresentationStyle = .fullScreen
        
        present(nextVC, animated: true)
    }
    
    private func giveShadow() {
        headerView.layer.borderWidth = 0
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        headerView.layer.shadowOpacity = 0.08
        headerView.layer.shadowRadius = 24
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(profileImageSelectorView)
        headerView.addSubview(nickNameLabel)
        headerView.addSubview(myMailLabel)
        headerView.addSubview(settingImageView)
        headerView.addSubview(separatorView)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 15, leading: view.leadingAnchor, leadingConstant: 10, trailing: view.trailingAnchor, trailingConstant: 10, height: 134)
        profileImageSelectorView.anchor(top: headerView.topAnchor, topConstant: 20, leading: headerView.leadingAnchor, leadingConstant: 20)
        nickNameLabel.anchor(top: headerView.topAnchor, topConstant: 35, leading: profileImageSelectorView.trailingAnchor, leadingConstant: 24)
        myMailLabel.anchor(top: nickNameLabel.bottomAnchor, topConstant: 7, leading: nickNameLabel.leadingAnchor)
        settingImageView.anchor(top: headerView.topAnchor, topConstant: 12, trailing: headerView.trailingAnchor, trailingConstant: 12)
        separatorView.anchor(top: profileImageSelectorView.bottomAnchor, topConstant: 10, leading: headerView.leadingAnchor, leadingConstant: 16, trailing: headerView.trailingAnchor, trailingConstant: 24, height: 4)
        tableView.anchor(top: headerView.bottomAnchor, topConstant: 15, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 55 * 3)
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
            navigationController?.pushViewController(MyPageStudyHistoryViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(MyPageSettingAlertTableViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(InformationViewController(), animated: true)
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

