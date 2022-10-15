//
//  MainViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/30.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Properties
    
    var study: [Study] = [Study(id: nil, isBlocked: nil, isPaused: nil, startDate: nil, endDate: nil)]
    private let masterSwitch = BrandSwitch()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureView()
        
    }
    
    private func configureView(){
        
        if study.isEmpty {
            view.backgroundColor = .systemBackground
            configureWhenNoStudy()
        } else {
            configureWhenStudyExist()
        }
    }
    
    // MARK: - Configure

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
        let tableView = UITableView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = UIColor.appColor(.background)
        
        tableView.register(MainFirstAnnouncementTableViewCell.self, forCellReuseIdentifier: MainFirstAnnouncementTableViewCell.identifier)
        tableView.register(MainSecondScheduleTableViewCell.self, forCellReuseIdentifier: MainSecondScheduleTableViewCell.identifier)
        tableView.register(MainThirdButtonTableViewCell.self, forCellReuseIdentifier: MainThirdButtonTableViewCell.identifier)
        tableView.register(MainFourthManagementTableViewCell.self, forCellReuseIdentifier: MainFourthManagementTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.appColor(.background)
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Setting Constraints
    
    
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

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFirstAnnouncementTableViewCell.identifier) as! MainFirstAnnouncementTableViewCell
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainSecondScheduleTableViewCell.identifier) as! MainSecondScheduleTableViewCell
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdButtonTableViewCell.identifier) as! MainThirdButtonTableViewCell
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFourthManagementTableViewCell.identifier) as! MainFourthManagementTableViewCell
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 20
        case 1:
            return 200
        case 2:
            return 70
        case 3:
            return 270
        default:
            return 100
        }
    }
}
