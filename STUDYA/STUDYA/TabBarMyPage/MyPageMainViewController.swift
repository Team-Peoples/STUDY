//
//  MyPageMainViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/08/21.
//

import UIKit
import Kingfisher

final class MyPageMainViewController: UIViewController {
    
    internal var user: User? {
        didSet {
            guard let userInfo = user else { return }
            nickNameLabel.text = userInfo.nickName
            myMailLabel.text = userInfo.id
            profileImageView.setImageWith(userInfo.imageURL)
        }
    }
    
    internal var myMail: String?
    
    private let numberOfRows = 2
    
    private let headerContainerView = UIView(backgroundColor: .appColor(.background))
    private let headerView: UIView = {
       
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        
        return view
    }()
    private let profileImageView = ProfileImageContainerView(size: 80)
    private lazy var nickNameLabel = CustomLabel(title: "", tintColor: .ppsBlack, size: 16, isBold: true, isNecessaryTitle: false)
    private lazy var myMailLabel = CustomLabel(title: myMail ?? "이메일 정보를 불러오지 못했습니다." , tintColor: .ppsGray1, size: 12)
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
        
        view.backgroundColor = .white
        
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
        // AccountManagerment에서 로그아웃하면서 이 VC가 한번 보여지고 사라지는지 이함수가 호출됨.
        
        navigationItem.title = "마이페이지"
        getUserInfo { user in
            self.user = user
        }
    }
    
    @objc private func settingViewTapped() {
        
        let nextVC = AccountManagementViewController()
        let navigationVC = UINavigationController(rootViewController: nextVC)
        
        navigationVC.modalPresentationStyle = .fullScreen
        
        present(navigationVC, animated: true)
    }
    
    private func getUserInfo(completion: @escaping (User) -> Void) {
        Network.shared.getUserInfo { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                switch error {
                case .unauthorizedUser:
                    AppController.shared.deleteUserInformationAndLogout()
                default:
                    UIAlertController.handleCommonErros(presenter: self, error: error)
                }
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(headerView)
        headerView.addSubview(profileImageView)
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
        profileImageView.anchor(top: headerView.topAnchor, topConstant: 20, leading: headerView.leadingAnchor, leadingConstant: 20)
        nickNameLabel.anchor(top: headerView.topAnchor, topConstant: 35, leading: profileImageView.trailingAnchor, leadingConstant: 24)
        myMailLabel.anchor(top: nickNameLabel.bottomAnchor, topConstant: 7, leading: nickNameLabel.leadingAnchor)
        settingImageView.anchor(top: headerView.topAnchor, topConstant: 12, trailing: headerView.trailingAnchor, trailingConstant: 12)
        separatorView.anchor(top: profileImageView.bottomAnchor, topConstant: 10, leading: headerView.leadingAnchor, leadingConstant: 16, trailing: headerView.trailingAnchor, trailingConstant: 24, height: 4)
        tableView.anchor(bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
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
//            navigationController?.pushViewController(MyPageSettingAlertTableViewController(), animated: true)
//        case 2:
            navigationController?.pushViewController(MyPageInformationViewController(), animated: true)
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

