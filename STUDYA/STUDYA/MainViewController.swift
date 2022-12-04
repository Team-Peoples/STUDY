//
//  MainViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/30.
//

import UIKit
//🛑to be updated: 네트워크로 방장 여부 확인받은 후 switchableVC 에서 isAdmin 값 didset에서 수정하도록
final class MainViewController: SwitchableViewController {
    // MARK: - Properties

    var myStudyList = [Study]() {
        didSet {
            if myStudyList.count < 5 {
                dropdownHeight = dropdownContainerView.heightAnchor.constraint(equalToConstant: CGFloat(myStudyList.count * 50) + createStudyButtonHeight)
            } else {
                dropdownHeight = dropdownContainerView.heightAnchor.constraint(equalToConstant: 200 + createStudyButtonHeight)
            }
            currentStudy = myStudyList[0]
            /// 스터디가 없을때는 안되지않나
//            currentStudy = myStudyList[0]
        }
    }
    var currentStudy: Study?
    
    var willDropDown = false
    private var willSpreadUp = false

    private lazy var notificationBtn: UIButton = {
        
        let n = UIButton(frame: .zero)
        
        n.setImage(UIImage(named: "noti"), for: .normal)
        n.setTitleColor(.black, for: .normal)
        n.addTarget(self, action: #selector(notificationButtonDidTapped), for: .touchUpInside)
        n.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 35)
        
        return n
    }()
    
    var dropDownCellNumber: CGFloat {
        if myStudyList.count == 0 {
            return 0
        } else if myStudyList.count > 0, myStudyList.count < 5 {
            return CGFloat(myStudyList.count)
        } else {
            return 4
        }
    }
    
    lazy var dropdownContainerView = UIView()
    lazy var dropdownTableView: UITableView = {

        let t = UITableView()
        
        t.delegate = self
        t.dataSource = self
        t.separatorColor = UIColor.appColor(.ppsGray3)
        t.bounces = false
        t.showsVerticalScrollIndicator = false
        t.register(MainDropDownTableViewCell.self, forCellReuseIdentifier: MainDropDownTableViewCell.identifier)

        return t
    }()
    lazy var dropdownDimmingView: UIView = {

        let v = UIView()

        v.isUserInteractionEnabled = true
        let recog = UITapGestureRecognizer(target: self, action: #selector(dropdownButtonDidTapped))
        v.addGestureRecognizer(recog)
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        v.isHidden = true

        return v
    }()
    lazy var createStudyButton: UIButton = {
       
        let b = UIButton()
        
        b.backgroundColor = UIColor.appColor(.brandMilky)
        b.setImage(UIImage(named: "plusCircleFill"), for: .normal)
        b.setTitle("   스터디 만들기", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 16)
        b.setTitleColor(UIColor.appColor(.keyColor1), for: .normal)
        b.isHidden = true
        b.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
        
        return b
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
    private lazy var floatingButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let normalImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .heavy))
        let selectedImage = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .heavy))

        btn.backgroundColor = .black
        btn.setImage(normalImage, for: .normal)
        btn.setImage(selectedImage, for: .selected)
        btn.tintColor = .white

        btn.layer.cornerRadius = 50 / 2
        btn.layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: 4, blur: 6, spread: 0)
        btn.addTarget(self, action: #selector(floatingButtonDidTapped), for: .touchUpInside)

        return btn
    }()
    private lazy var floatingButtonContainerView: UIView = {

        let v = UIView()
        v.isHidden = true

        return v
    }()
    private lazy var spreadUpDimmingView: UIView = {

        let v = UIView()

        v.isUserInteractionEnabled = true
        let recog = UITapGestureRecognizer(target: self, action: #selector(floatingButtonDidTapped))
        v.addGestureRecognizer(recog)
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        v.isHidden = true

        return v
    }()

    private let createStudyButtonHeight: CGFloat = 50
    private lazy var dropdownHeightZero = dropdownContainerView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var dropdownHeight = dropdownContainerView.heightAnchor.constraint(equalToConstant: createStudyButtonHeight)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        📣네트워킹으로 myStudyList 넣어주기
        
        myStudyList = [
            Study(id: 1, title: "팀피플즈", onoff: .on, category: .getJob, studyDescription: "우리의 스터디", freeRule: "강남역에서 종종 모여서 앱을 개발하는 스터디라고 할 수 있는 부분이 없지 않아 있다고 생각하는 부분이라고 봅니다.", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: nil, title: "우야노우리스터디", onoff: nil, category: nil, studyDescription: "느그 아부지", freeRule: "모하시노? 근달입니더. 니 오늘 쫌 맞자. 우리 동수 마이 컷네", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: nil, title: "무한도전", onoff: nil, category: nil, studyDescription: "보고 싶다", freeRule: "대리운전 불러어어어어 단거어어어어어어어어", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: 12, title: "팀피플즈", onoff: .on, category: .getJob, studyDescription: "우리의 스터디", freeRule: "강남역에서 종종 모여서 앱을 개발하는 스터디라고 할 수 있는 부분이 없지 않아 있다고 생각하는 부분이라고 봅니다.", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: nil, title: "우야노우리스터디", onoff: nil, category: nil, studyDescription: "느그 아부지", freeRule: "모하시노? 근달입니더. 니 오늘 쫌 맞자. 우리 동수 마이 컷네", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: nil, title: "무한도전", onoff: nil, category: nil, studyDescription: "보고 싶다", freeRule: "대리운전 불러어어어어 단거어어어어어어어어", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: 13, title: "팀피플즈", onoff: .on, category: .getJob, studyDescription: "우리의 스터디", freeRule: "강남역에서 종종 모여서 앱을 개발하는 스터디라고 할 수 있는 부분이 없지 않아 있다고 생각하는 부분이라고 봅니다.", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: nil, title: "우야노우리스터디", onoff: nil, category: nil, studyDescription: "느그 아부지", freeRule: "모하시노? 근달입니더. 니 오늘 쫌 맞자. 우리 동수 마이 컷네", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: nil, title: "무한도전", onoff: nil, category: nil, studyDescription: "보고 싶다", freeRule: "대리운전 불러어어어어 단거어어어어어어어어", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil)
        ]
        
        view.backgroundColor = .systemBackground
        myStudyList.isEmpty ? configureViewWhenNoStudy() : configureViewWhenYesStudy()
        configureDropdown()
        configureTabBarSeparator()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        floatingButtonContainerView.isHidden = true
    }
    
    // MARK: - Actions
    @objc private func notificationButtonDidTapped() {
        print(#function)
    }
    
    @objc private func dropdownButtonDidTapped() {
        toggleDropdown()
        dropdownDimmingView.isHidden.toggle()
    }
    
    @objc func createStudyButtonDidTapped() {
        dropdownButtonDidTapped()
        let creatingStudyFormVC = CreatingStudyFormViewController()
        
        creatingStudyFormVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let presentVC = UINavigationController(rootViewController: creatingStudyFormVC)
        
        presentVC.navigationBar.backIndicatorImage = UIImage(named: "back")
        presentVC.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        presentVC.modalPresentationStyle = .fullScreen
        
        present(presentVC, animated: true)
    }
    
    @objc private func floatingButtonDidTapped() {
        floatingButton.isSelected.toggle()
        spreadUpContainerView.isHidden.toggle()
        spreadUpDimmingView.isHidden.toggle()
        toggleSpreadUp()
    }
    
    override func extraWorkWhenSwitchToggled() {
        notificationBtn.isHidden = isSwitchOn ? true : false
        floatingButtonContainerView.isHidden = isSwitchOn ? false : true
        
        guard !isSwitchOn else { return }
        floatingButton.isSelected = false
    }
    
    private func toggleSpreadUp() {
        
        let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)]
        
        willSpreadUp.toggle()
        willSpreadUp ? spreadUpTableView.insertRows(at: indexPaths, with: .top) : spreadUpTableView.deleteRows(at: indexPaths, with: .top)
    }
    
    override func configureNavigationBar() {
        
        guard !myStudyList.isEmpty else { navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]; return }
        
        super.configureNavigationBar()
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]
    }
    
    func configureDropdown() {
        guard !myStudyList.isEmpty else { return }
        
        if let tabBarView = tabBarController?.view {
            tabBarView.addSubview(dropdownDimmingView)
            tabBarView.addSubview(dropdownContainerView)
            
            dropdownDimmingView.snp.makeConstraints { make in
                make.edges.equalTo(tabBarView)
            }
            dropdownContainerView.snp.makeConstraints { make in
                make.top.equalTo(dropdownDimmingView.snp.top).inset(100)
                make.leading.equalTo(dropdownDimmingView).inset(38)
                make.width.equalTo(206)
            }
        }
        
        dropdownContainerView.addSubview(dropdownTableView)
        dropdownContainerView.addSubview(createStudyButton)
        
        dropdownTableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(dropdownContainerView)
            make.bottom.equalTo(createStudyButton.snp.top)
        }
        
        createStudyButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(dropdownContainerView)
        }
        
        dropdownHeight.isActive = false
        dropdownHeightZero.isActive = true
    }
    
    private func toggleDropdown() {

        willDropDown.toggle()
        
        var indexPaths = [IndexPath]()
        var row = 0
        
        while row < myStudyList.count {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
            row += 1
        }
        
        if willDropDown {
            
            dropdownHeightZero.isActive = false
            dropdownHeight.isActive = true
            
            dropdownTableView.insertRows(at: indexPaths, with: .top)
            
            createStudyButton.isHidden = false
            createStudyButton.setHeight(50)
            
            dropdownContainerView.layer.cornerRadius = 24
            dropdownContainerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner)
            dropdownContainerView.clipsToBounds = true
            
            animateDropdown()
        } else {
            
            dropdownTableView.deleteRows(at: indexPaths, with: .top)

            dropdownHeight.isActive = false
            dropdownHeightZero.isActive = true
            createStudyButton.isHidden = true
            
            animateDropdown()
        }
    }
    
    private func animateDropdown() {
        let tabBarView = self.tabBarController?.view
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            tabBarView == nil ? self.view.layoutIfNeeded() : tabBarView?.layoutIfNeeded()
        }
    }
    
    private func configureViewWhenNoStudy() {
        let studyEmptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 150))
        let studyEmptyLabel = CustomLabel(title: "참여중인 스터디가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
        let createStudyButton = BrandButton(title: "스터디 만들기", isBold: true, isFill: true, fontSize: 20, height: 50)
        
        studyEmptyImageView.backgroundColor = .lightGray
        createStudyButton.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
        
        view.addSubview(studyEmptyImageView)
        view.addSubview(studyEmptyLabel)
        view.addSubview(createStudyButton)
        
        studyEmptyImageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(150)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(228)
            make.centerX.equalTo(view)
        }
        
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
        
        guard isAdmin else { return }
        
        configureFloatingButton()
        configureSpreadUp()
    }
    
    private func configureFloatingButton() {
        floatingButtonContainerView.isHidden = true
        tabBarController!.view.addSubview(floatingButtonContainerView)
        floatingButtonContainerView.addSubview(floatingButton)
        floatingButtonContainerView.snp.makeConstraints { make in
            make.trailing.equalTo(tabBarController!.view).inset(10)
            make.bottom.equalTo(tabBarController!.tabBar.snp.top).offset(-20)
            make.width.height.equalTo(50)
        }
        floatingButton.frame.origin = CGPoint(x: 0, y: 0)
        floatingButton.frame.origin = floatingButton.bounds.origin
    }
    
    private func configureSpreadUp() {
        spreadUpContainerView.backgroundColor = .clear
        spreadUpContainerView.isHidden = true
        
        tabBarController!.view.addSubview(spreadUpDimmingView)
        tabBarController!.view.addSubview(spreadUpContainerView)
        
        spreadUpContainerView.addSubview(spreadUpTableView)
        
        spreadUpDimmingView.snp.makeConstraints { make in
            make.edges.equalTo(tabBarController!.view)
        }
        
        spreadUpContainerView.anchor(bottom: floatingButtonContainerView.topAnchor, trailing: floatingButtonContainerView.trailingAnchor, width: 142, height: 186)
        spreadUpTableView.snp.makeConstraints { make in
            make.edges.equalTo(spreadUpContainerView)
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
        
        switch tableView {
        case mainTableView: return 6
        case dropdownTableView: return willDropDown ? myStudyList.count : 0
        case spreadUpTableView: return willSpreadUp ? 3 : 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case mainTableView:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainFirstStudyToggleTableViewCell.identifier) as! MainFirstStudyToggleTableViewCell
                
                cell.studyTitle = myStudyList.first?.title
                cell.buttonTapped = { self.dropdownButtonDidTapped() }
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainSecondScheduleTableViewCell.identifier) as! MainSecondScheduleTableViewCell
                
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdButtonTableViewCell.identifier) as! MainThirdButtonTableViewCell
                cell.navigatable = self
                
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainFourthAnnouncementTableViewCell.identifier) as! MainFourthAnnouncementTableViewCell
                cell.navigatable = self
                cell.announcement = Announcement(id: 1, studyID: 1, title: "오늘의 공지", content: "공지 송아지 양아치지공지 송아지 양아치지공지 송아지 양아치지공지 송아지 양아치지공지 송아지 양아치지공지 송아지 양아치지공지 송아지 양아치지", createdDate: nil, isPinned: true)
//                cell.hideTabBar = { [weak self] in
//                    self?.tabBarController?.tabBar.isHidden = true
//                }
//                
//                    cell.informationButtonAction = {
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc  = storyboard.instantiateViewController(withIdentifier: "StudyInfoViewController") as! StudyInfoViewController
//                        vc.study = self.myStudyList.first!
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
                    
                return cell
                
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainFifthAttendanceTableViewCell.identifier, for: indexPath) as! MainFifthAttendanceTableViewCell
                
                cell.studyAttendance = ["출석": 30, "지각": 15, "결석": 10, "사유": 5]
                cell.penalty = 9900
                cell.navigatableSwitchSyncableDelegate = self
                
                return cell
                
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainSixthETCTableViewCell.identifier, for: indexPath) as! MainSixthETCTableViewCell
                
                cell.currentStudy = currentStudy
                cell.navigatableSwitchSyncableDelegate = self
                
                return cell
            default:
                return UITableViewCell()
            }
        case dropdownTableView:
            
            guard let currentStudyID = currentStudy?.id else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: MainDropDownTableViewCell.identifier) as! MainDropDownTableViewCell
            
            if currentStudyID == myStudyList[indexPath.row].id {
                cell.isCurrentStudy = true
            }
            
            cell.study = myStudyList[indexPath.row]
            
            return cell
            
        case spreadUpTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainSpreadUpTableViewCell.identifier) as! MainSpreadUpTableViewCell
            cell.cellNumber = indexPath.row + 1
            
            return cell
        default: return UITableViewCell()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case mainTableView:
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
        case dropdownTableView:
            return 50
        case spreadUpTableView:
            return 62
        default: return 0
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

extension MainViewController {    
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
}
