//
//  MainViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/30.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    
    var study: [Study] = []
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationItem()
        checkStudyIsEmpty()
        
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
        print(sender.isOn)
    }
    
    @objc func createStudyButtonDidTapped() {
        let creatingStudyVC = CreatingStudyViewController()
        navigationController?.pushViewController(creatingStudyVC, animated: true)
    }
    
    private func checkStudyIsEmpty(){
        
        if study.isEmpty {
            
            let studyEmptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 150))
            studyEmptyImageView.backgroundColor = .lightGray
            let studyEmptyLabel = CustomLabel(title: "참여중인 스터디가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
            let createStudyButton = CustomButton(title: "스터디 만들기", isBold: true, isFill: true, size: 20, height: 50)
            createStudyButton.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
            
            view.addSubview(studyEmptyImageView)
            view.addSubview(studyEmptyLabel)
            view.addSubview(createStudyButton)
            
            setConstraints(studyEmptyImageView, studyEmptyLabel, createStudyButton)
        }
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
    }
    
    private func setConstraints(_ imageView: UIImageView, _ label: UILabel, _ button: UIButton) {
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(150)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(228)
            make.centerX.equalTo(view)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.width.equalTo(200)
            make.top.equalTo(label.snp.bottom).offset(10)
        }
    }
}
