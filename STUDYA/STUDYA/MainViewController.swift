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

    private var willSpreadUp = false

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
        
        t.register(MainFirstAnnouncementTableViewCell.self, forCellReuseIdentifier: MainFirstAnnouncementTableViewCell.identifier)
        t.register(MainSecondScheduleTableViewCell.self, forCellReuseIdentifier: MainSecondScheduleTableViewCell.identifier)
        t.register(MainThirdButtonTableViewCell.self, forCellReuseIdentifier: MainThirdButtonTableViewCell.identifier)
        t.register(MainFourthManagementTableViewCell.self, forCellReuseIdentifier: MainFourthManagementTableViewCell.identifier)
        
        t.separatorStyle = .none
        t.backgroundColor = UIColor.appColor(.background)
        t.isScrollEnabled = false
        
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

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
//        📣네트워킹으로 myStudyList 넣어주기
        
        myStudyList = [
            Study(id: 1, title: "팀피플즈", onoff: .on, category: .getJob, studyDescription: "우리의 스터디", freeRule: "강남역에서 종종 모여서 앱을 개발하는 스터디라고 할 수 있는 부분이 없지 않아 있다고 생각하는 부분이라고 봅니다.", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: nil, title: "개시끼야", onoff: nil, category: nil, studyDescription: "느그 아부지", freeRule: "모하시노? 근달입니더. 니 오늘 쫌 맞자. 우리 동수 마이 컷네", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
            Study(id: nil, title: "무한도전", onoff: nil, category: nil, studyDescription: "보고 싶다", freeRule: "대리운전 불러어어어어 단거어어어어어어어어", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil)
        ]
        
        view.backgroundColor = myStudyList.isEmpty ? .systemBackground : .appColor(.background2)
        myStudyList.isEmpty ? configureViewWhenNoStudy() : configureViewWhenYesStudy()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Actions
    @objc private func notificationButtonDidTapped() {
        print(#function)
    }
    
    @objc private func floatingButtonDidTapped() {
        floatingButton.isSelected.toggle()
        spreadUpContainerView.isHidden.toggle()
        spreadUpDimmingView.isHidden.toggle()
        toggleSpreadUp()
    }
    
    override func dropdownButtonDidTapped() {
        super.dropdownButtonDidTapped()
        notificationBtn.isHidden.toggle()
    }
    
    override func toggleNavigationBarBy(sender: BrandSwitch) {
        super.toggleNavigationBarBy(sender: sender)
        
        notificationBtn.isHidden.toggle()
        floatingButtonContainerView.isHidden.toggle()
        
        guard !sender.isOn else { return }
        floatingButton.isSelected = false
    }
    
    
    private func toggleSpreadUp() {
        
        let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)]
        
        willSpreadUp.toggle()
        willSpreadUp ? spreadUpTableView.insertRows(at: indexPaths, with: .top) : spreadUpTableView.deleteRows(at: indexPaths, with: .top)
    }
    
    override func configureNavigationItem() {
        
        guard !myStudyList.isEmpty else { navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn)]; return }
        
        super.configureNavigationItem()
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn), UIBarButtonItem(customView: dropdownButton)]
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
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case mainTableView: return 4
        case dropdownTableView: return willDropDown ? myStudyList.count : 0
        case spreadUpTableView: return willSpreadUp ? 3 : 0
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case mainTableView:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainFirstAnnouncementTableViewCell.identifier) as! MainFirstAnnouncementTableViewCell
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainSecondScheduleTableViewCell.identifier) as! MainSecondScheduleTableViewCell
                    cell.navigatable = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainThirdButtonTableViewCell.identifier) as! MainThirdButtonTableViewCell
                cell.navigatable = self
                
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: MainFourthManagementTableViewCell.identifier) as! MainFourthManagementTableViewCell
                cell.navigateDelegate = self
//                cell.hideTabBar = { [weak self] in
//                    self?.tabBarController?.tabBar.isHidden = true
//                }
                
                    cell.informationButtonAction = {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc  = storyboard.instantiateViewController(withIdentifier: "StudyInfoViewController") as! StudyInfoViewController
                        vc.study = self.myStudyList.first!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                return cell
            default:
                return UITableViewCell()
            }
        case dropdownTableView:
            guard let currentStudyID = currentStudy?.id else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MainDropDownTableViewCell.identifier) as! MainDropDownTableViewCell
            
            if currentStudyID == myStudyList[indexPath.row].id {
                cell.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 249/255, alpha: 1)
            }
            
            cell.title = myStudyList[indexPath.row].title!
            
            return cell
            
        case spreadUpTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainSpreadUpTableViewCell.identifier) as! MainSpreadUpTableViewCell
            cell.cellNumber = indexPath.row + 1
            
            return cell
        default: return UITableViewCell()
        }
    }
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case mainTableView:
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

extension MainViewController: Navigatable {
    func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
}
