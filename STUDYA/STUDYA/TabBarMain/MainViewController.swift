//
//  MainViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/30.
//

import UIKit

//🛑to be updated: 네트워크로 방장 여부 확인받은 후 switchableVC 에서 isManager 값 didset에서 수정하도록
final class MainViewController: SwitchableViewController {
    // MARK: - Properties
    
    internal var nickName: String?
    private var myStudyList = [Study]()
    private var currentStudyOverall: StudyOverall?
    private var imminentAttendanceInformation: AttendanceInformation?
//    private var notification: String? {
//        didSet {
//            if notification != nil {
//                notificationBtn.setImage(UIImage(named: "noti-new"), for: .normal)
//            }
//        }
//    }
    private var isRefreshing = false
    
    private lazy var notificationBtn: UIButton = {
        
        let n = UIButton(frame: .zero)
        
        n.setImage(UIImage(named: "noti"), for: .normal)
        n.setTitleColor(.black, for: .normal)
        n.addTarget(self, action: #selector(notificationButtonDidTapped), for: .touchUpInside)
        n.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 35)
        
        return n
    }()
    
    private lazy var mainTableView: UITableView = {
        
        let t = UITableView()
        
        t.delegate = self
        t.dataSource = self
        
        t.register(MainFirstStudyToggleTableViewCell.self, forCellReuseIdentifier: MainFirstStudyToggleTableViewCell.identifier)
        t.register(MainSecondScheduleTableViewCell.self, forCellReuseIdentifier: MainSecondScheduleTableViewCell.identifier)
        t.register(MainThirdButtonTableViewCell.self, forCellReuseIdentifier: MainThirdButtonTableViewCell.identifier)
        t.register(MainFourthAnnouncementTableViewCell.self, forCellReuseIdentifier: MainFourthAnnouncementTableViewCell.identifier)
        t.register(MainFifthAttendanceTableViewCell.self, forCellReuseIdentifier: MainFifthAttendanceTableViewCell.identifier)
        t.register(MainSixthETCTableViewCell.self, forCellReuseIdentifier: MainSixthETCTableViewCell.identifier)
        
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        t.backgroundColor = .white
        t.refreshControl = UIRefreshControl()
        
        t.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return t
    }()
    
    private lazy var floatingButton: UIButton = {
        let btn = UIButton(frame: .zero)
        let normalImage = UIImage(named: "mainFloatingPlus")
        let selectedImage = UIImage(named: "mainFloatingDismiss")

        btn.setImage(normalImage, for: .normal)
        btn.setImage(selectedImage, for: .selected)
        btn.addTarget(self, action: #selector(floatingButtonDidTapped), for: .touchUpInside)

        return btn
    }()
    private lazy var floatingButtonContainerView: UIView = {

        let v = UIView()
        v.isHidden = true

        return v
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Network.shared.attend(in: 289, with: 4561) { result in
//            switch result {
//            case .success(let attendanceInformation):
//                print("success")
//
//
//            case .failure(let error):
//                print("fail")
//            }
//        }
//        Network.shared.createStudySchedule(StudySchedulePosting(studyID: 118, studyScheduleID: nil, topic: "아무거나", place: "강남역", startDate: "2023-04-02", repeatEndDate: "", startTime: "01:28", endTime: "01:29", repeatOption: .norepeat)) { result in
//            switch result {
//            case .success:
//                print("suc")
//                Network.shared.getAllStudyScheduleOfAllStudy { result in
//                    switch result {
//                    case .success(let all):
//                        print(all)
//                    case .failure:
//                        print("fuck")
//                    }
//                }
//            case .failure:
//                print("fa")
//            }
//        }
//
//        Network.shared.getAllStudyScheduleOfAllStudy { result in
//            switch result {
//            case .success(let all):
//                print(all)
//            case .failure:
//                print("fuck")
//            }
//        }
        
//        Network.shared.deleteStudySchedule(<#T##studyScheduleID: ID##ID#>, deleteRepeatSchedule: false) { result in
//            switch result {
//            case .success:
//                print("deleted")
//            case .failure:
//                print("delete fail")
//            }
//        }
        
//        Network.shared.createAnnouncement(title: "test1", content: "테스트중", studyID: 109) { result in
//            switch result {
//            case .success(let announcements):
//                print(announcements)
//            case .failure:
//                print("fail")
//            }
//        }
//        Network.shared.joinStudy(id: 149) { result in
//            switch result {
//            case .success(let suc):
//                print("🍓🍓")
//                print(suc)
//            case .failure(let err):
//                print("🍓")
//                print(err)
//            }
//        }
        
//        Network.shared.createStudy(Study(id: nil, studyName: "똥싸고 커피마시기", studyOn: true, studyOff: false, category: .certificate, studyIntroduction: "그러면 기분이가 좋지요.", freeRule: "똥은 천천히 싸기", isBlocked: nil, isPaused: nil, generalRule: GeneralStudyRule(lateness: Lateness(time: 5, count: 5, fine: 500), absence: Absence(time: 30, fine: 5000), deposit: 10000, excommunication: Excommunication(lateness: 10, absence: 4)))) { result in
//            switch result {
//            case .success:
//                print("succ")
//            case .failure:
//                print("fail")
//            }
//        }
        
        getUserInformationAndStudies()
        
        view.backgroundColor = .white
        print("postman의 key 입력하는 곳에 바로 붙여넣기, cmd + c GO")
//        print("----------------------------------------------------------")
//        print("""
//            [{"key":"AccessToken","value":"Bearer \(KeychainService.shared.read(key: Constant.accessToken)!)","description":null,"type":"text","enabled":true,"equals":true},{"key":"RefreshToken","value":"Bearer \(KeychainService.shared.read(key: Constant.refreshToken)!)","description":"","type":"text","enabled":true}]
//            """)
//        print("----------------------------------------------------------")
        configureTabBarSeparator()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStudyList), name: .reloadStudyList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCurrentStudy), name: .reloadCurrentStudy, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .systemBackground
//        self.navigationItem.standardAppearance = appearance
//        self.navigationItem.scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        self.navigationItem.standardAppearance = nil
//        self.navigationItem.scrollEdgeAppearance = nil
    }
    var flag = true
    
    // MARK: - Actions
    
    @objc private func notificationButtonDidTapped() {
        let nextVC = NotificationViewController()
        push(vc: nextVC)
    }
    
    @objc private func createStudyButtonDidTapped() {
        if currentStudyOverall != nil {
            dropdownButtonDidTapped()
        }
        let creatingStudyFormVC = CreatingStudyFormViewController()
        
        creatingStudyFormVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let presentVC = UINavigationController(rootViewController: creatingStudyFormVC)
        
        presentVC.navigationBar.backIndicatorImage = UIImage(named: "back")
        presentVC.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        presentVC.modalPresentationStyle = .fullScreen
        
        present(presentVC, animated: true)
    }
    
    @objc private func dropdownButtonDidTapped() {
        let dimmingVC = MainDropDownDimmingViewController()
        
        dimmingVC.modalTransitionStyle = .crossDissolve
        dimmingVC.modalPresentationStyle = .overFullScreen
        dimmingVC.myStudyList = myStudyList
        dimmingVC.currentStudy = currentStudyOverall?.study
        dimmingVC.studyTapped = { [weak self] studyOverall in
            self?.reloadTableViewWithCurrentStudy(studyOverall: studyOverall)
            self?.forceSwitchStatus(isOn: false)
        }
        dimmingVC.presentCreateNewStudyVC = { sender in self.present(sender, animated: true) }
        
        present(dimmingVC, animated: true)
    }
    
    @objc private func floatingButtonDidTapped() {
        floatingButton.isSelected = true
        guard let studyID = currentStudyOverall?.study.id else { return }
        let dimmingVC = MainSpreadUpDimmingViewController(studyID: studyID)
        
        dimmingVC.modalTransitionStyle = .crossDissolve
        dimmingVC.modalPresentationStyle = .overFullScreen
        dimmingVC.tabBarHeight = tabBarController?.tabBar.frame.height ?? 83
        dimmingVC.dimmingViewTappedAction = { self.floatingButton.isSelected = false }
        dimmingVC.presentNextVC = { sender in
            self.present(sender, animated: true) { self.floatingButton.isSelected = false }
        }
        
        present(dimmingVC, animated: true)
    }
    
    @objc private func refresh() {
        isRefreshing = true
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        getUserInformationAndStudies()
    }
    
    @objc private func reloadStudyList() {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        getAllStudies()
    }
    
    @objc private func reloadCurrentStudy() {
        guard let studyID = currentStudyOverall?.study.id else { return }
        Network.shared.getAllStudies { result in
            switch result {
            case .success(let studies):
                
                guard let currentStudy = studies.filter({ $0.id == studyID }).first,
                      let currentStudyID = currentStudy.id else {
                    return self.configureViewWhenNoStudy()
                }
                
                self.myStudyList = studies
                self.configureTableView(with: currentStudyID)
                
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
        Network.shared.getStudy(studyID: studyID) { result in
            
            switch result {
            case .success(let studyOverall):
                
                self.reloadTableViewWithCurrentStudy(studyOverall: studyOverall)
                self.configureTableViewThirdCell()
                
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    override func extraWorkWhenSwitchToggled(isOn: Bool) {

//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .appColor(.keyColor1)
//        self.navigationItem.standardAppearance = appearance
//        self.navigationItem.scrollEdgeAppearance = appearance
        
        let thirdCellIndexPath = IndexPath(row: 2, section: 0)
        mainTableView.reloadRows(at: [thirdCellIndexPath], with: .automatic)
        
        notificationBtn.isHidden = isOn
        floatingButtonContainerView.isHidden = !isOn
        
        guard !isOn else { return }
        floatingButton.isSelected = false
    }
    
//    MARK: - initializing Data
    private func getUserInformationAndStudies() {
        Network.shared.getUserInfo { result in
            switch result {
                
            case .success(let user):
                self.nickName = user.nickName
                
                // 카카오톡 사용자 초대 링크생성시 파라미터를 담아 전달해야하는데, 그떄 nickname과 studyName이 필요해서 만들었음.
                KeychainService.shared.create(key: Constant.nickname, value: user.nickName!)
                self.getAllStudies()
            case .failure(let error):
                
                switch error {
                case .userNotFound:
                    let alert = SimpleAlert(buttonTitle: Constant.OK, message: "잘못된 접근입니다. 다시 로그인해주세요.") { finished in
                        AppController.shared.deleteUserInformationAndLogout()
                    }
                    self.present(alert, animated: true)
                default:
                    UIAlertController.handleCommonErros(presenter: self, error: error)
                }
            }
        }
    }
    
    private func getAllStudies() {
        Network.shared.getAllStudies { result in
            switch result {
            case .success(let studies):
                
                if let firstStudy = studies.first, let studyID = firstStudy.id {
                    self.myStudyList = studies
                    self.configureTableView(with: studyID)
                    print("studyID", studyID)
                } else {
                    self.configureViewWhenNoStudy()
                }
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func configureTableView(with studyID: ID) {
        Network.shared.getStudy(studyID: studyID) { result in
            
            switch result {
            case .success(let studyOverall):
                // 스터디정보를 처음으로 가져온다.
                // 카카오톡 사용자 초대 링크생성시 파라미터를 담아 전달해야하는데, 그떄 nickname과 studyName이 필요해서 만들었음.
                KeychainService.shared.create(key: Constant.currentStudyName, value: studyOverall.study.studyName!)
                // domb: 중복된 작업인건지 물어보기
                self.isManager = studyOverall.isManager
                self.configureViewWhenYesStudy()
                self.reloadTableViewWithCurrentStudy(studyOverall: studyOverall)
                
                self.configureTableViewThirdCell()
                
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func reloadTableViewWithCurrentStudy(studyOverall: StudyOverall) {
        var study = studyOverall.study
        let studyOwnerNickname = studyOverall.ownerNickname
        study.ownerNickname = studyOwnerNickname
        
        DispatchQueue.global().async {
            let data = try? JSONEncoder().encode(study)
            UserDefaults.standard.removeObject(forKey: Constant.currentStudy)
            UserDefaults.standard.set(data, forKey: Constant.currentStudy)
        }

        self.currentStudyOverall = studyOverall
        // domb: 중복된 작업인건지 물어보기
        isManager = studyOverall.isManager
        mainTableView.reloadData()
    }
    
    private func configureViewWhenYesStudy() {
        configureTableView()
        configureFloatingButtonIfManagerMode()
    }
    
    private func configureTableView() {
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureFloatingButtonIfManagerMode() {
        guard isManager else { return }
        
        configureFloatingButton()
    }
    
    private func configureTableViewThirdCell() {
        if let scheduleID = currentStudyOverall?.studySchedule?.studyScheduleID {
            reloadTableViewThirdCell(with: scheduleID)
        } else {
            self.imminentAttendanceInformation = nil
            mainTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            endRefreshIfIsRefreshing()
        }
    }
    
    private func reloadTableViewThirdCell(with id: ID) {
        Network.shared.getImminentScheduleAttendance(scheduleID: id) { result in
            switch result {
            case .success(let attendanceInfo):
                self.reloadTableViewThirdCell(with: attendanceInfo)
                self.endRefreshIfIsRefreshing()
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func reloadTableViewThirdCell(with attendanceInfo: AttendanceInformation) {
        if attendanceInfo.attendanceStatus != nil {
            self.imminentAttendanceInformation = attendanceInfo
        } else {
            self.imminentAttendanceInformation = nil
        }
        mainTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
    }
    
    private func configureViewWhenNoStudy() {
        let studyEmptyImageView = UIImageView(image: UIImage(named: "emptyViewImage"))
        let studyEmptyLabel = CustomLabel(title: "참여중인 스터디가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
        let createStudyButton = BrandButton(title: "스터디 만들기", isBold: true, isFill: true, fontSize: 20, height: 50)
        
        createStudyButton.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
        
        view.addSubview(studyEmptyImageView)
        view.addSubview(studyEmptyLabel)
        view.addSubview(createStudyButton)
        
        studyEmptyImageView.centerXY(inView: view, yConstant: -Constant.screenHeight * 0.06)
        
        studyEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(studyEmptyImageView)
            make.top.equalTo(studyEmptyImageView.snp.bottom).offset(20)
        }
        
        createStudyButton.snp.makeConstraints { make in
            make.centerX.equalTo(studyEmptyImageView)
            make.width.equalTo(200)
            make.top.equalTo(studyEmptyLabel.snp.bottom).offset(10)
        }
        
        endRefreshIfIsRefreshing()
    }
    
    private func endRefreshIfIsRefreshing() {
        if isRefreshing {
            mainTableView.refreshControl?.endRefreshing()
        }
    }
    
//    override func configureNavigationBar() {
//        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]
//        guard !myStudyList.isEmpty else { return }
//
//        super.configureNavigationBar()
//    }
    
    private func configureNavigationBarNotiBtn() {
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]
    }

    private func configureFloatingButton() {
        let isSwitchOn = UserDefaults.standard.bool(forKey: Constant.isSwitchOn)
        floatingButtonContainerView.isHidden = !isSwitchOn
        view.addSubview(floatingButtonContainerView)
        floatingButtonContainerView.addSubview(floatingButton)
        floatingButtonContainerView.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(15)
            make.bottom.equalTo(view).inset(100)
            make.width.height.equalTo(50)
        }
        floatingButton.snp.makeConstraints { make in
            make.leading.top.equalTo(floatingButtonContainerView)
        }
    }
    
    
    private func configureTabBarSeparator() {
        if let tabBar = tabBarController?.tabBar {
            
            let separator = UIView(frame: .zero)
            
            separator.backgroundColor = .appColor(.ppsGray2)
            
            tabBar.addSubview(separator)
            
            separator.snp.makeConstraints { make in
                make.leading.trailing.equalTo(tabBar)
                make.height.equalTo(1)
                make.top.equalTo(tabBar.snp.top)
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainFirstStudyToggleTableViewCell.identifier) as? MainFirstStudyToggleTableViewCell else { return MainFirstStudyToggleTableViewCell() }
            
            cell.configureCellWithStudyTitle(studyTitle: currentStudyOverall?.study.studyName)
            cell.buttonTapped = { self.dropdownButtonDidTapped() }
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSecondScheduleTableViewCell.identifier) as? MainSecondScheduleTableViewCell else { return MainSecondScheduleTableViewCell() }
            
            cell.navigatableManagableDelegate = self
            cell.configureCellWith(nickName: nickName, schedule: currentStudyOverall?.studySchedule)

            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdButtonTableViewCell.identifier) as? MainThirdButtonTableViewCell else { return MainThirdButtonTableViewCell() }
            
            cell.navigatableDelegate = self
            cell.configureCellWith(attendanceInformation: imminentAttendanceInformation, studySchedule: currentStudyOverall?.studySchedule)
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainFourthAnnouncementTableViewCell.identifier) as? MainFourthAnnouncementTableViewCell else { return MainFourthAnnouncementTableViewCell() }
            
            cell.navigatable = self
            cell.configureCell(with: currentStudyOverall?.announcement)
            
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainFifthAttendanceTableViewCell.identifier, for: indexPath) as? MainFifthAttendanceTableViewCell else { return MainFifthAttendanceTableViewCell() }
            
            guard let currentStudyOverall = currentStudyOverall else { return MainFifthAttendanceTableViewCell() }
            
            cell.delegate = self
            cell.configureCellWithStudy(currentStudyOverall)
            
            return cell
            
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSixthETCTableViewCell.identifier, for: indexPath) as? MainSixthETCTableViewCell else { return MainSixthETCTableViewCell() }
            
            cell.navigatableManagableDelegate = self
            cell.configureCellWith(currentStudyID: currentStudyOverall?.study.id, currentStudyName: currentStudyOverall?.study.studyName)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case mainTableView:
            if indexPath.row == 1 {
                guard let currentStudyOverall = currentStudyOverall, let studyID = currentStudyOverall.study.id else { return }
                let studyScheduleVC = StudyScheduleViewController(studyID: studyID)
                
                studyScheduleVC.title = currentStudyOverall.study.studyName
                
                self.syncManager(with: studyScheduleVC)
                self.push(vc: studyScheduleVC)
                
            } else if indexPath.row == 3 {
                guard let currentStudyOverall = currentStudyOverall, let studyID = currentStudyOverall.study.id else { return }
                
                saveAnnouncementIDUserAlreadyCheckedInStudy(studyID)
                
                guard let studyName = currentStudyOverall.study.studyName else { return }
                let announcementTableVC = AnnouncementTableViewController(studyID: studyID, studyName: studyName)
                
                self.syncManager(with: announcementTableVC)
                self.push(vc: announcementTableVC)
            }
            
        default: break
        }
    }
    
    private func saveAnnouncementIDUserAlreadyCheckedInStudy(_ studyID: ID) {
        guard let announcementID = currentStudyOverall?.announcement?.id else { return }
        UserDefaults.standard.set(announcementID, forKey: "checkedAnnouncementIDOfStudy\(studyID)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 50
        case 1:
            return 165
        case 2:
            return 90
        case 3:
            return 60
        case 4:
            return 175
        default:
            return 70
        }
    }
}
