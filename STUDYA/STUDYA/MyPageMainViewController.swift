//
//  MyPageMainViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/21.
//

import UIKit
import Kingfisher

final class MyPageMainViewController: UIViewController {
    
    internal var userInfo: User? {
        didSet {
            guard let userInfo = userInfo else { return }
            nickNameLabel.text = userInfo.nickName
            myMailLabel.text = userInfo.id
            guard let imageURL = userInfo.image else { return }
            let url = URL(string: imageURL)
            profileImageSelectorView.internalImageView.kf.setImage(with: url)
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
        headerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(headerContainerView).inset(15)
            make.leading.trailing.equalTo(headerContainerView).inset(10)
        }
        profileImageSelectorView.snp.makeConstraints { make in
            make.top.leading.equalTo(headerView).inset(20)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView).inset(35)
            make.leading.equalTo(profileImageSelectorView.snp.trailing).offset(24)
        }
        myMailLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(7)
            make.leading.equalTo(nickNameLabel)
        }
        settingImageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(headerView).inset(12)
        }
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(profileImageSelectorView.snp.bottom).offset(10)
            make.leading.equalTo(headerView).inset(16)
            make.trailing.equalTo(headerView).inset(24)
            make.height.equalTo(4)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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

