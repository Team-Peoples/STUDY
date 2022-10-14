//
//  MainViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/30.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Properties
    
    var study: [Study] = []
    private let masterSwitch = BrandSwitch()
    
    private lazy var tableView = UITableView(frame: .zero)
    
    private lazy var announcementBackView = UIView(frame: .zero)
    private lazy var scheduleBackView = UIView(frame: .zero)
//    let attend
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationItem()
        configureView()
        
        setConstraints()
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        let notificationBtn = UIButton(type: .custom)
        
        notificationBtn.setImage(UIImage(named: "noti"), for: .normal)
        notificationBtn.setTitleColor(.black, for: .normal)
        notificationBtn.addTarget(self, action: #selector(notificationButtonDidTapped), for: .touchUpInside)
        
        masterSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: notificationBtn)
    }
    
    // MARK: - Actions

    @objc func addButtonDidTapped() {
        let createStudyVC = CreatingStudyViewController()
        navigationController?.pushViewController(createStudyVC, animated: true)
    }
    
    @objc func notificationButtonDidTapped() {
        print(#function)
    }
    
    @objc func switchValueChanged(sender: BrandSwitch) {
        
        if sender.isOn {
            
            navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
            navigationItem.title = "관리자 모드"
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        } else {
            
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationItem.title = nil
            navigationController?.navigationBar.tintColor = .black
        }
    }
    
    @objc func createStudyButtonDidTapped() {
        let creatingStudyVC = CreatingStudyViewController()
        navigationController?.pushViewController(creatingStudyVC, animated: true)
    }
    
    @objc private func scheduleTapped() {
        
    }
    
    private func configureView(){
        
        if study.isEmpty {
            configureWhenNoStudy()
        } else {
            configureWhenStudyExist()
        }
    }
    
    private func configureWhenNoStudy() {
        let studyEmptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 150))
        let studyEmptyLabel = CustomLabel(title: "참여중인 스터디가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
        let createStudyButton = CustomButton(title: "스터디 만들기", isBold: true, isFill: true, size: 20, height: 50)
        
        studyEmptyImageView.backgroundColor = .lightGray
        createStudyButton.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
        
        view.addSubview(studyEmptyImageView)
        view.addSubview(studyEmptyLabel)
        view.addSubview(createStudyButton)
        
        setConstraints(studyEmptyImageView, studyEmptyLabel, createStudyButton)
    }
    
    private func configureWhenStudyExist() {
        view.backgroundColor = UIColor.appColor(.background)
        
        view.addSubview(announcementBackView)
        
        announcementBackView.backgroundColor = UIColor.appColor(.ppsGray2)
        announcementBackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 24)
        
        configureAnnouncement()
        
        
        scheduleBackView.layer.cornerRadius = 20
        scheduleBackView.backgroundColor = .systemBackground
        
        view.addSubview(scheduleBackView)
        
        scheduleBackView.anchor(top: announcementBackView.bottomAnchor, topConstant: 20, leading: view.leadingAnchor, leadingConstant: 20, trailing: view.trailingAnchor, trailingConstant: 20, height: 180)
        
        let title = CustomLabel(title: "일정", tintColor: .ppsBlack, size: 20, isBold: true, isNecessaryTitle: false)
        let disclosureButton = UIButton(frame: .zero)
        disclosureButton.setImage(UIImage(named: "circleDisclosureIndicator"), for: .normal)
        disclosureButton.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        let subtitle = CustomLabel(title: "다가오는 일정", tintColor: .ppsBlack, size: 16, isBold: true, isNecessaryTitle: false)
        let date = CustomLabel(title: "00월00일 (월) | am 00:00", tintColor: .ppsGray1, size: 16, isBold: true, isNecessaryTitle: false)
        let place = CustomLabel(title: "강남역 공간이즈", tintColor: .ppsGray1, size: 12)
        let today = CustomLabel(title: "동사와 형용사", tintColor: .ppsGray1, size: 12)
        
        scheduleBackView.addSubview(title)
        scheduleBackView.addSubview(disclosureButton)
        scheduleBackView.addSubview(subtitle)
        scheduleBackView.addSubview(date)
        scheduleBackView.addSubview(place)
        scheduleBackView.addSubview(today)
        
        title.anchor(top: scheduleBackView.topAnchor, topConstant: 20, leading: scheduleBackView.leadingAnchor, leadingConstant: 32)
        disclosureButton.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.trailing.equalTo(scheduleBackView.snp.trailing).offset(-12)
        }
        subtitle.anchor(top: title.bottomAnchor, topConstant: 24, leading: scheduleBackView.leadingAnchor, leadingConstant: 32)
        date.anchor(top: subtitle.bottomAnchor, topConstant: 12, leading: subtitle.leadingAnchor)
        place.anchor(top: date.bottomAnchor, topConstant: 2, leading: date.leadingAnchor, trailing: scheduleBackView.trailingAnchor, trailingConstant: 20)
        today.anchor(top: place.bottomAnchor, topConstant: 13, leading: place.leadingAnchor, trailing: place.trailingAnchor)
    }
    
    private func configureAnnouncement() {
        
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
