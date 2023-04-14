//
//  MainViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/30.
//

import UIKit

final class MainViewModel {
    var isManager = Observable(false)
    
    var nickName = ""
    var myStudyList = [Study]()
    
    lazy var currentStudyOverall: Observable<StudyOverall?> = Observable(dummyStudyOverall)
    lazy var imminentAttendanceInformation: Observable<AttendanceInformation?> = Observable(dummyAttendanceInformation)
    
    var dummyStudyOverall = StudyOverall(announcement: nil, ownerNickname: "dummyStudyOverall", study: Study(), isManager: false, totalFine: 999, attendedCount: 999, absentCount: 999, lateCount: 999, allowedCount: 999, timeLeftUntilNextStudy: 999, studySchedule: StudySchedule(studyName: "dummyStudyName", studyScheduleID: 999, studyID: "dummyStudyID", topic: "dummyTopic", place: "dummyPlace", startDateAndTime: Date(timeIntervalSince1970: 10), endDateAndTime: Date(timeIntervalSince1970: 20), repeatOption: nil), isOwner: false)
    var dummyAttendanceInformation = AttendanceInformation(userID: "dummyAttendanceInformation", attendanceStatus: "dummyStatus", reason: "dummyReason", fine: 999)
    
    var error = Observable(PeoplesError.noError)
    
    func getUserInformationAndStudies() {
        Network.shared.getUserInfo { result in
            switch result {
                
            case .success(let user):
                guard let nickName = user.nickName else { return }
                
                UserDefaults.standard.set(nickName, forKey: Constant.nickname)
                
                self.getFirstStudyAfterGettingAllStudies()
                
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func getAllStudies(completion: @escaping ([Study]) -> Void) {
        Network.shared.getAllStudies { result in
            switch result {
            case .success(let studies):
                
                self.myStudyList = studies
                completion(studies)
                
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func getCurrentStudyAfterGettingAllStudies() {
        getAllStudies { _ in
            self.getStudy(with: self.currentStudyOverall.value?.study.id)
        }
    }
    
    func getFirstStudyAfterGettingAllStudies() {
        getAllStudies { studies in
            self.getFirstStudy(in: studies)
        }
    }
    
    func getTHEStudyAfterGettingAllStudies(studyID: ID?) {
        getAllStudies { studies in
            guard let theStudy = studies.filter({ $0.id == studyID }).first,
                  let theStudyID = theStudy.id else {
                
                self.error.value = .serverError
                return
            }
            
            self.getStudy(with: theStudyID)
        }
    }
    
    func getFirstStudy(in studies: [Study]) {
        if let firstStudy = studies.first, let studyID = firstStudy.id {
            
            self.getStudy(with: studyID)
        } else {
            self.currentStudyOverall.value = nil
        }
    }
    
    func getStudy(with studyID: ID?, completion: @escaping (() -> Void) = {}) {
        guard let studyID = studyID else { return }
        
        Network.shared.getStudy(studyID: studyID) { result in
            
            switch result {
            case .success(let studyOverall):
                // 스터디정보를 처음으로 가져온다.
                guard let currentStudyName = studyOverall.study.studyName else { return }
                
                UserDefaults.standard.set(currentStudyName, forKey: Constant.currentStudyName)
                UserDefaults.standard.set(studyID, forKey: Constant.currentStudyID)
                
                // domb: 중복된 작업인건지 물어보기
                self.isManager.value = studyOverall.isManager || studyOverall.isOwner
                self.currentStudyOverall.value = studyOverall
                self.getImminentAttendanceInformation()
                completion()
                print("studyID", studyID)
                
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func getImminentAttendanceInformation() {
        guard let scheduleID = currentStudyOverall.value?.studySchedule?.studyScheduleID else { return }
        Network.shared.getImminentScheduleAttendance(scheduleID: scheduleID) { result in
            switch result {
            case .success(let attendanceInfo):
                self.imminentAttendanceInformation.value = attendanceInfo
                
            case .failure(let error):
                self.error.value = error
            }
        }
    }
}

//🛑to be updated: 네트워크로 방장 여부 확인받은 후 switchableVC 에서 isManager 값 didset에서 수정하도록
final class MainViewController: SwitchableViewController, LinkShareable {
    // MARK: - Properties
    
    private var viewModel = MainViewModel()
    
    private var isRefreshing = false
    
    private lazy var notificationBtn: UIButton = {
        
        let n = UIButton()
        
        n.setImage(UIImage(named: "noti"), for: .normal)
        n.setTitleColor(.black, for: .normal)
        n.addTarget(self, action: #selector(notificationButtonDidTapped), for: .touchUpInside)
        n.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 35)
        
        return n
    }()
    
    let studyEmptyImageView = UIImageView(image: UIImage(named: "emptyViewImage"))
    let studyEmptyLabel = CustomLabel(title: "참여중인 스터디가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
    let createStudyButton = BrandButton(title: "스터디 만들기", isBold: true, isFill: true, fontSize: 20, height: 50)
    
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
    private lazy var floatingButtonContainerView = UIView()
    
    lazy var noStudyViews = [studyEmptyImageView, studyEmptyLabel, createStudyButton]
    lazy var yesStudyviews = [mainTableView, floatingButton, floatingButtonContainerView]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getUserInformationAndStudies()
        
        view.backgroundColor = .white
        
        print("postman의 key 입력하는 곳에 바로 붙여넣기, cmd + c GO")
        print("----------------------------------------------------------")
        print("""
            [{"key":"AccessToken","value":"Bearer \(KeychainService.shared.read(key: Constant.accessToken)!)","description":null,"type":"text","enabled":true,"equals":true},{"key":"RefreshToken","value":"Bearer \(KeychainService.shared.read(key: Constant.refreshToken)!)","description":"","type":"text","enabled":true}]
            """)
        print("----------------------------------------------------------")
        configureViewsInitially()
        configureTabBarSeparator()
        setBinding()
        
        createStudyButton.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStudyList(_:)), name: .reloadStudyList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCurrentStudy), name: .reloadCurrentStudy, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]
    }
    
    // MARK: - Actions
    
    @objc private func notificationButtonDidTapped() {
        let nextVC = NotificationViewController()
        push(vc: nextVC)
    }
    
    @objc private func createStudyButtonDidTapped() {
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
        dimmingVC.myStudyList = viewModel.myStudyList
        dimmingVC.currentStudy = viewModel.currentStudyOverall.value?.study
        dimmingVC.studyTapped = { [weak self] studyOverall in
            guard let weakSelf = self else { return }
            
            weakSelf.viewModel.getStudy(with: studyOverall.study.id)
            weakSelf.viewModel.isManager.value = studyOverall.isManager || studyOverall.isOwner
            weakSelf.forceSwitchStatus(isOn: false)
        }
        dimmingVC.presentCreateNewStudyVC = { sender in self.present(sender, animated: true) }
        
        present(dimmingVC, animated: true)
    }
    
    @objc private func floatingButtonDidTapped() {
        floatingButton.isSelected = true
        guard let studyID = viewModel.currentStudyOverall.value?.study.id else { return }
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
        viewModel.getStudy(with: viewModel.currentStudyOverall.value?.study.id) {
            self.mainTableView.refreshControl?.endRefreshing()
            self.isRefreshing = false
        }
    }
    
    @objc private func reloadStudyList(_ noti: Notification) {
        if let userInfo = noti.userInfo,
           let studyID = userInfo[Constant.studyID] as? ID {
            viewModel.getTHEStudyAfterGettingAllStudies(studyID: studyID)
        } else {
            viewModel.getFirstStudyAfterGettingAllStudies()
        }
    }
    
    @objc private func reloadCurrentStudy() {
        viewModel.getStudy(with: viewModel.currentStudyOverall.value?.study.id) {
            self.viewModel.getImminentAttendanceInformation()
            self.mainTableView.reloadData()
        }
    }
    
    override func extraWorkWhenSwitchToggled(isOn: Bool) {
        
        let thirdCellIndexPath = IndexPath(row: 2, section: 0)
        mainTableView.reloadRows(at: [thirdCellIndexPath], with: .automatic)
        
        guard viewModel.isManager.value == true else { return }
        notificationBtn.isHidden = isOn
        floatingButtonContainerView.isHidden = !isOn
        floatingButton.isHidden = !isOn
        
        guard !isOn else { return }
        floatingButton.isSelected = false
    }
    
    private func setBinding() {
        viewModel.isManager.bind { isManager in
            self.isManager = isManager
        }
        
        viewModel.currentStudyOverall.bind { [self] studyOverall in
            if studyOverall == nil {
                showNoStudyViews()
                
            } else {
                guard studyOverall != viewModel.dummyStudyOverall else { return }
                showYesStudyViews()
                mainTableView.reloadData()
            }
        }
        
        viewModel.imminentAttendanceInformation.bind { _ in
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
        
        viewModel.error.bind { error in
            switch error {
            case .userNotFound:
                let alert = SimpleAlert(buttonTitle: Constant.OK, message: "잘못된 접근입니다. 다시 로그인해주세요.") { finished in
                    AppController.shared.deleteUserInformationAndLogout()
                }
                self.present(alert, animated: true)
            case .noError: break
            default:
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func showYesStudyViews() {
        noStudyViews.forEach { $0.isHidden = true }
        mainTableView.isHidden = false
        
        let isSwitchOn = UserDefaults.standard.bool(forKey: Constant.isSwitchOn)
        floatingButtonContainerView.isHidden = viewModel.isManager.value && isSwitchOn ? false : true
        floatingButton.isHidden = viewModel.isManager.value && isSwitchOn ? false : true
    }
    
    private func showNoStudyViews() {
        noStudyViews.forEach { $0.isHidden = false }
        yesStudyviews.forEach { $0.isHidden = true }
    }
    
    private func configureNavigationBarNotiBtn() {
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]
    }
    
    private func configureViewsInitially() {
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
        view.subviews.forEach( { $0.isHidden = true } )
        
        
//        activityIndicator.center = view.center
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
    }
//    let activityIndicator = UIActivityIndicatorView(style: .medium)
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
            
            cell.configureCellWithStudyTitle(studyTitle: viewModel.currentStudyOverall.value?.study.studyName)
            cell.buttonTapped = { self.dropdownButtonDidTapped() }
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSecondScheduleTableViewCell.identifier) as? MainSecondScheduleTableViewCell else { return MainSecondScheduleTableViewCell() }
            
            cell.navigatableManagableDelegate = self
            
            let nickname = UserDefaults.standard.value(forKey: Constant.nickname) as? String
            
            cell.configureCellWith(nickName: nickname, schedule: viewModel.currentStudyOverall.value?.studySchedule)

            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdButtonTableViewCell.identifier) as? MainThirdButtonTableViewCell else { return MainThirdButtonTableViewCell() }
            
            cell.navigatableDelegate = self
            cell.configureCellWith(attendanceInformation: viewModel.imminentAttendanceInformation.value, studySchedule: viewModel.currentStudyOverall.value?.studySchedule)
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainFourthAnnouncementTableViewCell.identifier) as? MainFourthAnnouncementTableViewCell else { return MainFourthAnnouncementTableViewCell() }
            
            cell.navigatable = self
            cell.configureCell(with: viewModel.currentStudyOverall.value?.announcement)
            
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainFifthAttendanceTableViewCell.identifier, for: indexPath) as? MainFifthAttendanceTableViewCell else { return MainFifthAttendanceTableViewCell() }
            
            cell.delegate = self
            cell.configureCellWithStudy(viewModel.currentStudyOverall.value)
            
            return cell
            
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSixthETCTableViewCell.identifier, for: indexPath) as? MainSixthETCTableViewCell else { return MainSixthETCTableViewCell() }
            
            cell.navigatableManagableDelegate = self
            cell.configureCellWith(currentStudyID: viewModel.currentStudyOverall.value?.study.id, currentStudyName: viewModel.currentStudyOverall.value?.study.studyName)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentStudyOverall = viewModel.currentStudyOverall.value, let studyID = currentStudyOverall.study.id else { return }
        
        if indexPath.row == 1 {
            
            let studyScheduleVC = StudyScheduleViewController(studyID: studyID)
            
            studyScheduleVC.title = currentStudyOverall.study.studyName
            
            self.syncManager(with: studyScheduleVC)
            self.push(vc: studyScheduleVC)
            
        } else if indexPath.row == 3 {
            
            saveAnnouncementIDUserAlreadyCheckedInStudy(studyID)
            
            guard let studyName = currentStudyOverall.study.studyName else { return }
            let announcementTableVC = AnnouncementTableViewController(studyID: studyID, studyName: studyName)
            
            self.syncManager(with: announcementTableVC)
            self.push(vc: announcementTableVC)
        }
    }
    
    private func saveAnnouncementIDUserAlreadyCheckedInStudy(_ studyID: ID) {
        guard let announcementID = viewModel.currentStudyOverall.value?.announcement?.id else { return }
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
