//
//  MyPageMainViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/21.
//

import UIKit

final class MyPageMainViewController: UIViewController {
    
    internal var userInfo: User? {
        didSet {
            guard let userInfo = userInfo else { return }
            nickNameLabel.text = userInfo.nickName
            myMailLabel.text = userInfo.id
            // 이미지 설정
        }
    }
    
    internal var nickName: String?
    internal var myMail: String?
    
    private let numberOfRows = 3
    
    private let headerContainerView = UIView(backgroundColor: .appColor(.background))
    private let headerView: UIView = {
       
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        
        return view
    }()
    private let profileImageSelectorView = ProfileImageView(size: 80)
    private lazy var nickNameLabel = CustomLabel(title: nickName ?? "닉네임", tintColor: .ppsBlack, size: 16, isBold: true, isNecessaryTitle: false)
    private lazy var myMailLabel = CustomLabel(title: myMail ?? "peoples.noreply@gmail.com" , tintColor: .ppsGray1, size: 12)
    private let settingImageView = UIImageView(image: UIImage(named: "setting"))
    private let separatorView: RoundableView = {
       
        let view = RoundableView(cornerRadius: 2)
        view.backgroundColor = UIColor.appColor(.ppsGray3)
        
        return view
    }()
    private let tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
        tableView.rowHeight = 55
        tableView.separatorStyle = .none
        tableView.backgroundColor = .appColor(.background)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "마이페이지"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        
        headerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 10, spread: 0)
        
        settingImageView.isUserInteractionEnabled = true
        settingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingViewTapped)))
        
        addSubviews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo { user in
            self.userInfo = user
        }
    }
    
    @objc private func settingViewTapped() {
        
        let nextVC = AccountManagementViewController()
        
        getUserInfo { userInfo in
           // 이미지
            nextVC.nickName = userInfo.nickName
            nextVC.email = userInfo.id
            if let naver = userInfo.isNaverLogin, !naver {
                nextVC.sns = .naver
            }
            if let kakao = userInfo.isKakaoLogin , !kakao {
                nextVC.sns = .kakao
            }
        }
        
        nextVC.modalPresentationStyle = .fullScreen
        
        present(nextVC, animated: true)
    }
    
    private func getUserInfo(completion: @escaping (User) -> Void) {
        Network.shared.getUserInfo { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(headerView)
        headerView.addSubview(profileImageSelectorView)
        headerView.addSubview(nickNameLabel)
        headerView.addSubview(myMailLabel)
        headerView.addSubview(settingImageView)
        headerView.addSubview(separatorView)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        headerContainerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(tableView.snp.top)
            make.height.equalTo(164)
        }
        headerView.anchor(top: headerContainerView.topAnchor, topConstant: 15, leading: headerContainerView.leadingAnchor, leadingConstant: 10, trailing: headerContainerView.trailingAnchor, trailingConstant: 10, height: 134)
        profileImageSelectorView.anchor(top: headerView.topAnchor, topConstant: 20, leading: headerView.leadingAnchor, leadingConstant: 20)
        nickNameLabel.anchor(top: headerView.topAnchor, topConstant: 35, leading: profileImageSelectorView.trailingAnchor, leadingConstant: 24)
        myMailLabel.anchor(top: nickNameLabel.bottomAnchor, topConstant: 7, leading: nickNameLabel.leadingAnchor)
        settingImageView.anchor(top: headerView.topAnchor, topConstant: 12, trailing: headerView.trailingAnchor, trailingConstant: 12)
        separatorView.anchor(top: profileImageSelectorView.bottomAnchor, topConstant: 10, leading: headerView.leadingAnchor, leadingConstant: 16, trailing: headerView.trailingAnchor, trailingConstant: 24, height: 4)
        tableView.anchor(top: headerContainerView.bottomAnchor, topConstant: 15, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 55 * 3)
    }
}

extension MyPageMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else { return MyPageTableViewCell() }
        
        cell.row = indexPath.row
        
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
            navigationController?.pushViewController(MyPageInformationViewController(), animated: true)
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

