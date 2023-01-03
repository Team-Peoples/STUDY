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
    
    internal var nickName: String? {
        didSet {
            
        }
    }
    private var myStudyList = [Study]() {
        didSet {
            
        }
    }
    private var currentStudyOverall: StudyOverall? {
        didSet {
            guard let currentStudyOverall = currentStudyOverall else { return }
            isManager = currentStudyOverall.isManager
            mainTableView.reloadData()
        }
    }
    private var notification: String? {
        didSet {
            if notification != nil {
                notificationBtn.setImage(UIImage(named: "noti-new"), for: .normal)
            }
        }
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
//        📣네트워킹으로 myStudyList 넣어주기
        getUserInformationAndStudies()
//        myStudyList = [
//            Study(id: 1, studyName: "웃기지마", studyOn: true, studyOff: false, category: .dev_prod_design, studyIntroduction: "우리의 스터디", freeRule: "강남역에서 종종 모여서 앱을 개발하는 스터디라고 할 수 있는 부분이 없지 않아 있다고 생각하는 부분이라고 봅니다.", isBlocked: nil, isPaused: nil, generalRule: GeneralStudyRule(lateness: Lateness(time: 10, count: 1, fine: 5000), absence: Absence(time: 30, fine: 10000), deposit: 10000, excommunication: Excommunication(lateness: 10, absence: 5))),
//            Study(id: 2, studyName: "무한도전", studyOn: true, studyOff: false, category: .dev_prod_design, studyIntroduction: "우리의 스터디", freeRule: "대리운전 불러어어어어 단거어어어어어어어어", isBlocked: nil, isPaused: nil, generalRule: GeneralStudyRule(lateness: Lateness(time: 10, count: 1, fine: 5000), absence: Absence(time: 30, fine: 10000), deposit: 10000, excommunication: Excommunication(lateness: 10, absence: 5))),
//            Study(id: 3, studyName: "우야노우리스터디", studyOn: true, studyOff: false, category: .dev_prod_design, studyIntroduction: "느그 아부지", freeRule: "모하시노? 근달입니더. 니 오늘 쫌 맞자. 우리 동수 마이 컷네", isBlocked: nil, isPaused: nil, generalRule: GeneralStudyRule(lateness: Lateness(time: 10, count: 1, fine: 5000), absence: Absence(time: 30, fine: 10000), deposit: 10000, excommunication: Excommunication(lateness: 10, absence: 5)))
//        ]
//        currentStudyOverall = StudyOverall(announcement: nil, study: myStudyList.first!, isManager: true, totalFine: 0, attendedCount: 0, absentcount: 0, totalStudyHeldCount: 0, lateCount: 0, allowedCount: 0, studySchedule: nil, ownerID: "d")
        
        
        view.backgroundColor = .systemBackground
//        myStudyList.isEmpty ? configureViewWhenNoStudy() : configureViewWhenYesStudy()
        
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
        flag.toggle()
        
//        Network.shared.createStudySchedule(StudyScheduleGoing(studyId: 3, studyName: nil, studyScheduleID: 3, topic: "묘오오오오오픽", place: "ㅏㅏㅏ앙소", openDate: "2023-01-01", deadlineDate: "2023-01-01", startTime: "16:30", endTime: "17:00", repeatOption: .noRepeat)) { result in
//            switch result {
//            case .success:
//                print("s")
//            case .failure(let error):
//                UIAlertController.handleCommonErros(presenter: self, error: error)
//            }
//        }
//        Network.shared.getAllStudySchedule { result in
//            switch result {
//            case .success(let schedules):
//                print(schedules)
//            case .failure(let error):
//                UIAlertController.handleCommonErros(presenter: self, error: error)
//            }
//        }
//        Network.shared.deleteStudySchedule(48, deleteRepeatSchedule: false) { result in
//            switch result {
//            case .success:
//                print("S")
//            case .failure(let error):
//                UIAlertController.handleCommonErros(presenter: self, error: error)
//            }
//        }
        
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
        dimmingVC.studyTapped = { sender in self.currentStudyOverall = sender }
        dimmingVC.presentCreateNewStudyVC = { sender in self.present(sender, animated: true) }
        
        present(dimmingVC, animated: true)
    }
    
    @objc private func floatingButtonDidTapped() {
        floatingButton.isSelected = true
        
        let dimmingVC = MainSpreadUpDimmingViewController()
        
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
    
    private func getUserInformationAndStudies() {
        Network.shared.getUserInfo { result in
            switch result {
                
            case .success(let user):
                print(KeyChain.read(key: Const.accessToken))
                print(KeyChain.read(key: Const.refreshToken))
                self.nickName = user.nickName
                self.getAllStudies()
            case .failure(let error):
                print(#function,1)
                switch error {
                case .userNotFound:
                    
                    DispatchQueue.main.async {
                        let alert = SimpleAlert(buttonTitle: Const.OK, message: "잘못된 접근입니다. 다시 로그인해주세요.") { finished in
                            AppController.shared.deleteUserInformationAndLogout()
                        }
                        self.present(alert, animated: true)
                    }
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
                print(#function,1)
                if let firstStudy = studies.first {
                    
                    self.myStudyList = studies
                    self.getCurrentStudyOverall(study: firstStudy)
                } else {
                    print(#function,2)
                    DispatchQueue.main.async {
                        self.configureViewWhenNoStudy()
                    }
                }
            case .failure(let error):
                print(#function,3)
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func getCurrentStudyOverall(study: Study) {
        guard let studyID = study.id else { return }
        Network.shared.getStudy(studyID: studyID) { result in
            
            switch result {
            case .success(let studyOverall):
                self.isManager = studyOverall.isManager
                
                self.currentStudyOverall = studyOverall
                DispatchQueue.main.async {
                    self.configureViewWhenYesStudy()
                }
            case .failure(let error):
                print(#function,2)
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
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
    
    private func configureViewWhenNoStudy() {
        let studyEmptyImageView = UIImageView(image: UIImage(named: "emptyViewImage"))
        let studyEmptyLabel = CustomLabel(title: "참여중인 스터디가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
        let createStudyButton = BrandButton(title: "스터디 만들기", isBold: true, isFill: true, fontSize: 20, height: 50)
        
        studyEmptyImageView.backgroundColor = .lightGray
        createStudyButton.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
        
        view.addSubview(studyEmptyImageView)
        view.addSubview(studyEmptyLabel)
        view.addSubview(createStudyButton)
        
        studyEmptyImageView.centerXY(inView: view, yConstant: -Const.screenHeight * 0.06)
        
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
    
    private func configureViewWhenYesStudy() {
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        guard isManager else { return }
        
        configureFloatingButton()
    }
    
    private func configureFloatingButton() {
        floatingButtonContainerView.isHidden = true
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
            print(#function, "🤟")
            let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdButtonTableViewCell.identifier) as! MainThirdButtonTableViewCell
            
//            cell.schedule = currentStudyOverall?.studySchedule
            cell.schedule = StudySchedule(studyID: nil, studyName: nil, studyScheduleID: nil, topic: nil, place: nil, startTime: Date(timeIntervalSinceNow: -300), endTime: Date(timeIntervalSinceNow: 3600), repeatOption: nil)
            cell.navigatableSwitchObservableDelegate = self            
            
            if flag {
                cell.didAttend = true
                cell.attendanceStatus = .attended
                
            } else {
                cell.didAttend = true
                cell.attendanceStatus = .absent
            }
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFourthAnnouncementTableViewCell.identifier) as! MainFourthAnnouncementTableViewCell
            
            cell.navigatable = self
            cell.announcement = currentStudyOverall?.announcement

            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainFifthAttendanceTableViewCell.identifier, for: indexPath) as! MainFifthAttendanceTableViewCell
            
            guard let currentStudyOverall = currentStudyOverall else { return MainFifthAttendanceTableViewCell() }
            
            cell.studyAttendance = [
                .attended: currentStudyOverall.attendedCount,
                .late: currentStudyOverall.lateCount,
                .absent: currentStudyOverall.absentcount,
                .allowed: currentStudyOverall.allowedCount
            ]
            cell.totalStudyHeldCount = currentStudyOverall.totalStudyHeldCount
            
            cell.penalty = currentStudyOverall.totalFine
            cell.navigatableSwitchSyncableDelegate = self
            
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
                let announcementBoardVC = AnnouncementBoardViewController()
                self.syncSwitchWith(nextVC: announcementBoardVC)
                self.push(vc: announcementBoardVC)
            }
        default: break
        }
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
//
//extension MainViewController: UIPopoverControllerDelegate {
//    class PresentAsPopover : NSObject, UIPopoverPresentationControllerDelegate {
//
//        // 싱글턴 사용, delegate property는 weak 니까 instance를 미리 받아놔야한다.
//        private static let sharedInstance = AlwaysPresentAsPopover()
//
//        private override init() {
//            super.init()
//        }
//
//        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//            return .none
//        }
//
//        static func configurePresentation(forController controller : UIViewController) -> UIPopoverPresentationController {
//            let presentationController = controller.presentationController as! UIPopoverPresentationController
//            presentationController.delegate = AlwaysPresentAsPopover.sharedInstance
//            return presentationController
//        }
//}

extension MainViewController: SwitchStatusObservable {
    func getSwtichStatus() -> Bool {
        isSwitchOn
    }
}

protocol SwitchStatusObservable {
    func getSwtichStatus() -> Bool
}
