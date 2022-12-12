//
//  NotificationViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/04.
//

import UIKit

final class NotificationViewController: UIViewController {
    
    private lazy var noNotiImageView = UIImageView(image: UIImage(named: "noNotification"))
    private lazy var noNotiLabel = CustomLabel(title: "알림이 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
    
    private lazy var tableView: UITableView = {
       
        let t = UITableView(frame: .zero)
        
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .systemBackground
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        t.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.setBrandNavigation()
        
        title = "알림"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appColor(.ppsBlack)]
        
        configureViewWhenNoNotification()
    }
    
    private func configureViewWhenNoNotification() {
        view.addSubview(noNotiImageView)
        view.addSubview(noNotiLabel)
        
        noNotiImageView.centerXY(inView: view)
        noNotiLabel.centerX(inView: view)
        noNotiLabel.anchor(top: noNotiImageView.bottomAnchor, topConstant: 20)
    }
    
    private func configureViewWhenYesNotification() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier) as! NotificationTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        93
    }
}

extension NotificationViewController: UITableViewDelegate {
    
}
