//
//  MainSpreadUpViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/10.
//

import UIKit

final class MainSpreadUpViewController: UIViewController {
    
    private var willSpreadUp = false
    
    private var dimmingViewTappedAction: () -> () = {}
    
    private lazy var spreadUpContainerView = UIView()
    private lazy var spreadUpTableView: UITableView = {

        let t = UITableView()

        t.delegate = self
        t.dataSource = self
        t.separatorStyle = .none
        t.backgroundColor = .clear
        t.bounces = false
        t.showsVerticalScrollIndicator = false
        t.register(MainSpreadUpTableViewCell.self, forCellReuseIdentifier: MainSpreadUpTableViewCell.identifier)

        return t
    }()
    private lazy var spreadUpDimmingViewButton = UIButton()
    
    private var tabBarHeight: CGFloat?
    private let interTabBarSpaceHeight: CGFloat = 84
    init(tabBarHeight: CGFloat, dimmingViewTappedAction: @escaping (() -> ()) ) {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarHeight = tabBarHeight
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        self.dimmingViewTappedAction = dimmingViewTappedAction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spreadUpContainerView.backgroundColor = .clear
        
        spreadUpDimmingViewButton.addTarget(self, action: #selector(dimmingViewTapped), for: .touchUpInside)
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
            self.view.backgroundColor = .black.withAlphaComponent(0.6)
        } completion: { finished in
            self.spreadUp()
        }
    }
    
    
    @objc private func dimmingViewTapped() {
        dimmingViewTappedAction()
        dismiss(animated: true)
    }
    
    private func spreadUp() {
        
        let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]
        willSpreadUp.toggle()
        spreadUpTableView.insertRows(at: indexPaths, with: .top)
    }
    
    private func configureView() {
        view.addSubview(spreadUpDimmingViewButton)
        view.addSubview(spreadUpContainerView)
        spreadUpContainerView.addSubview(spreadUpTableView)
        
        spreadUpDimmingViewButton.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        spreadUpContainerView.anchor(bottom: view.bottomAnchor, bottomConstant: tabBarHeight! + interTabBarSpaceHeight, trailing: view.trailingAnchor, trailingConstant: 10, width: 142, height: 136)
        spreadUpTableView.snp.makeConstraints { make in
            make.edges.equalTo(spreadUpContainerView)
        }
    }
}

extension MainSpreadUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        willSpreadUp ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSpreadUpTableViewCell.identifier) as? MainSpreadUpTableViewCell else { return UITableViewCell()}
        
        cell.row = indexPath.row
        
        return cell
    }
}

extension MainSpreadUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let creatingAnnouncementVC = AnnouncementViewController(task: .creating)
            creatingAnnouncementVC.isMaster = true
            
            let navigationVC = UINavigationController(rootViewController: creatingAnnouncementVC)
            navigationVC.modalPresentationStyle = .fullScreen
            
            present(navigationVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        62
    }
}
