//
//  MainViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/30.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationItem()
        
        setConstraints()
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        let noticeBtn = UIButton(type: .custom)
        let masterSwitch = BrandSwitch()
        
        noticeBtn.setImage(UIImage(named: "noti"), for: .normal)
        noticeBtn.setTitleColor(.black, for: .normal)
        noticeBtn.addTarget(self, action: #selector(noticeButtonDidTapped), for: .touchUpInside)
        
        masterSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: noticeBtn)
    }
    
    // MARK: - Actions

    @objc func addButtonDidTapped() {
        let createStudyVC = CreatingStudyViewController()
        navigationController?.pushViewController(createStudyVC, animated: true)
    }
    
    @objc func noticeButtonDidTapped() {
        print(#function)
    }
    
    @objc func switchValueChanged(sender: BrandSwitch) {
        print(sender)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
    }
}
