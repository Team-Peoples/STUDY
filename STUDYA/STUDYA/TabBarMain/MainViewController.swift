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
    private var currentStudyOverall: StudyOverall? {
        didSet {
            guard let currentStudyOverall = currentStudyOverall else { return }
            print("studyID: \(currentStudyOverall.study.id)")
            isManager = currentStudyOverall.isManager
            mainTableView.reloadData()
        }
    }
    private var imminentAttendanceInformation: AttendanceInformation? {
        didSet {
            mainTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
    }
    private var notification: String? {
        didSet {
            if notification != nil {
                notificationBtn.setImage(UIImage(named: "noti-new"), for: .normal)
            }
        }
    }
    
    private lazy var changeImminentStudyScheduleAttendanceInformationTo: ((AttendanceInformation) -> Void) = { attendanceInformation in
        guard let studyID = self.currentStudyOverall?.study.id else { return }  //클로저명 바꿔야함
        Network.shared.getStudy(studyID: studyID) { result in
            
            switch result {
            case .success(let studyOverall):
                
                self.isManager = studyOverall.isManager
                self.currentStudyOverall = studyOverall
                
                self.setImminentStudyScheduleAttendanceImformation()
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
//        self.imminentAttendanceInformation = attendanceInformation
    }
    
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
        t.backgroundColor = .systemBackground
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
//        Network.shared.createStudySchedule(StudySchedulePosting(studyID: 118, studyScheduleID: nil, topic: "아무거나", place: "강남역", startDate: "2023-02-28", repeatEndDate: "", startTime: "01:57", endTime: "01:59", repeatOption: .norepeat)) { result in
//            switch result {
//            case .success:
//                print("suc")
//            case .failure:
//                print("fa")
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

//        Network.shared.joinStudy(id: 110) { result in
//            switch result {
//            case .success(let suc):
//                print(suc)
//            case .failure(let err):
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
        
        view.backgroundColor = .systemBackground
        
        print("origin accessToken: ",KeyChain.read(key: Constant.accessToken)!)
        print("origin refreshToken: ",KeyChain.read(key: Constant.refreshToken)!)
        
        configureTabBarSeparator()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
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
    
//        let nextVC = NotificationViewController()
//        push(vc: nextVC)
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
        dimmingVC.currentStudy = currentStudyOverall?.study
        dimmingVC.myStudyList = myStudyList
        dimmingVC.currentStudy = currentStudyOverall?.study
        dimmingVC.studyTapped = { sender in self.currentStudyOverall = sender }
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
    
    override func extraWorkWhenSwitchToggled() {

//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .appColor(.keyColor1)
//        self.navigationItem.standardAppearance = appearance
//        self.navigationItem.scrollEdgeAppearance = appearance
        
        let thirdCellIndexPath = IndexPath(row: 2, section: 0)
        mainTableView.reloadRows(at: [thirdCellIndexPath], with: .automatic)
        
        notificationBtn.isHidden = isSwitchOn ? true : false
        floatingButtonContainerView.isHidden = isSwitchOn ? false : true
        
        guard !isSwitchOn else { return }
        floatingButton.isSelected = false
    }
    
//    MARK: - initializing Data
    private func getUserInformationAndStudies() {
        Network.shared.getUserInfo { result in
            switch result {
                
            case .success(let user):
                self.nickName = user.nickName
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
                    self.getCurrentStudyOverall(with: studyID)
                    print("studyID", studyID)
                } else {
                    self.configureViewWhenNoStudy()
                }
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func getCurrentStudyOverall(with studyID: ID) {
        Network.shared.getStudy(studyID: studyID) { result in
            
            switch result {
            case .success(let studyOverall):
                
                self.isManager = studyOverall.isManager
                self.currentStudyOverall = studyOverall
                
                self.configureViewWhenYesStudy()
                self.setImminentStudyScheduleAttendanceImformation()
                
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    @objc private func refresh() {
        getUserInformationAndStudies()
        mainTableView.refreshControl?.endRefreshing()
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
    
    private func setImminentStudyScheduleAttendanceImformation() {
        if let scheduleID = currentStudyOverall?.studySchedule?.studyScheduleID {
            getImminentScheudleAttendanceInformation(with: scheduleID)
        } else {
            self.imminentAttendanceInformation = nil
        }
    }
    
    private func getImminentScheudleAttendanceInformation(with id: ID) {
        Network.shared.getImminentScheduleAttendance(scheduleID: id) { result in
            switch result {
            case .success(let attendanceInfo):
                self.save(attendanceInfo)
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func save(_ attendanceInfo: AttendanceInformation) {
        if attendanceInfo.attendanceStatus != nil {
            self.imminentAttendanceInformation = attendanceInfo
        } else {
            self.imminentAttendanceInformation = nil
        }
    }
    
    private func configureViewWhenNoStudy() {
        let studyEmptyImageView = UIImageView(image: UIImage(named: "emptyViewImage"))
        let studyEmptyLabel = CustomLabel(title: "참여중인 스터디가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
        let createStudyButton = BrandButton(title: "스터디 만들기", isBold: true, isFill: true, fontSize: 20, height: 50)
        
        studyEmptyImageView.backgroundColor = .lightGray
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
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]
        guard !myStudyList.isEmpty else { return }
        
        super.configureNavigationBar()
    }
    
    private func configureNavigationBarNotiBtn() {
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]
    }

    private func configureFloatingButton() {
        floatingButtonContainerView.isHidden = isSwitchOn ? false : true
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
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFirstStudyToggleTableViewCell.identifier) as! MainFirstStudyToggleTableViewCell
            
            cell.studyTitle = currentStudyOverall?.study.studyName
            cell.buttonTapped = { self.dropdownButtonDidTapped() }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainSecondScheduleTableViewCell.identifier) as! MainSecondScheduleTableViewCell
            
            cell.nickName = nickName
            cell.schedule = currentStudyOverall?.studySchedule
            cell.navigatableSwitchSyncableDelegate = self
            
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdButtonTableViewCell.identifier) as! MainThirdButtonTableViewCell
            
            print("currentStudy: \(currentStudyOverall?.study.id), scheduleID: \(currentStudyOverall?.studySchedule?.studyScheduleID)")
            cell.schedule = currentStudyOverall?.studySchedule
            cell.navigatableSwitchObservableDelegate = self
            cell.attendanceInformation = imminentAttendanceInformation
            cell.schedule = currentStudyOverall?.studySchedule
            cell.changeImminentStudyScheduleAttendanceInformationTo = changeImminentStudyScheduleAttendanceInformationTo
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFourthAnnouncementTableViewCell.identifier) as! MainFourthAnnouncementTableViewCell
            
            cell.navigatable = self
            
            cell.studyID = currentStudyOverall?.study.id
            cell.announcement = currentStudyOverall?.announcement

            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFifthAttendanceTableViewCell.identifier, for: indexPath) as! MainFifthAttendanceTableViewCell
            
            guard let currentStudyOverall = currentStudyOverall else { return MainFifthAttendanceTableViewCell() }
            
            cell.currentStudyOverall = currentStudyOverall
            
            cell.delegate = self
            
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainSixthETCTableViewCell.identifier, for: indexPath) as! MainSixthETCTableViewCell
            
            cell.currentStudyID = currentStudyOverall?.study.id
            cell.navigatableSwitchSyncableDelegate = self
            
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
            if indexPath.row == 3 {
                guard let studyID = currentStudyOverall?.study.id else { return }
                
                saveAnnouncementIDUserAlreadyCheckedInStudy(studyID)
                
                let announcementTableVC = AnnouncementTableViewController(studyID: studyID)
                
                self.syncSwitchWith(nextVC: announcementTableVC)
                self.push(vc: announcementTableVC)
            }
            if indexPath.row == 1 {
                guard let studyID = currentStudyOverall?.study.id else { return }
                let studyScheduleVC = StudyScheduleViewController(studyID: studyID)
                
                self.syncSwitchWith(nextVC: studyScheduleVC)
                self.push(vc: studyScheduleVC)
            }
        default: break
        }
    }
    
    private func saveAnnouncementIDUserAlreadyCheckedInStudy(_ studyID: ID) {
        guard let announcementID = currentStudyOverall?.announcement?.id else { return }
        UserDefaults.standard.setValue(announcementID, forKey: "checkedAnnouncementIDOfStudy\(studyID)")
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

protocol SwitchStatusGivable {
    var isSwitchOn: Bool { get set }
    
    func getSwtichStatus() -> Bool
}

extension SwitchStatusGivable {
    func getSwtichStatus() -> Bool {
        isSwitchOn
    }
}
