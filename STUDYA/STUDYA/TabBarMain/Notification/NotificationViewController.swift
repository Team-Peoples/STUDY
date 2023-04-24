//
//  NotificationViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/04.
//

import UIKit

final class NotificationViewController: UIViewController {
    
    var notifications: [Noti]? {
        didSet {
            guard let notifications = notifications else { return }
            
            if notifications.isEmpty {
                configureViewWhenNoNotification()
            } else {
                configureViewWhenYesNotification()
            }
        }
    }
    
    private lazy var noNotiImageView = UIImageView(image: UIImage(named: "noNotification"))
    private lazy var noNotiLabel = CustomLabel(title: "알림이 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
    
    private lazy var tableView: UITableView = {
       
        let t = UITableView(frame: .zero)
        
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .white
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        t.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        getAllNotifications()
        
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    private func getAllNotifications() {
        Network.shared.getAllNotifications { result in
            switch result {
            case .success(let notifications):
                print(notifications)
                self.notifications = notifications
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func configureViewWhenNoNotification() {
        view.addSubview(noNotiImageView)
        view.addSubview(noNotiLabel)
        
        noNotiImageView.centerXY(inView: view)
        noNotiImageView.anchor(width: 120, height: 180)
        noNotiLabel.centerX(inView: view)
        noNotiLabel.anchor(top: noNotiImageView.bottomAnchor, topConstant: 20)
    }
    
    private func configureViewWhenYesNotification() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setNavigationBar() {
        title = "알림"
        navigationController?.setupBrandNavigation()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appColor(.ppsBlack)]
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notifications = notifications else { return 0 }
        
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier) as? NotificationTableViewCell,
              let notifications = notifications else { return NotificationTableViewCell() }
        
        cell.notificaion = notifications[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        93
    }
}

extension NotificationViewController: UITableViewDelegate {
    
}
