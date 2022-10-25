//
//  MainViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/30.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Properties
    
    private var myStudies: [Study] = [
        Study(id: 1, title: "팀피플즈", onoff: nil, category: nil, studyDescription: "우리의 스터디", freeRule: "강남역에서 종종 모여서 앱을 개발하는 스터디라고 할 수 있는 부분이 없지 않아 있다고 생각하는 부분이라고 봅니다.", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
        Study(id: nil, title: "개시끼야", onoff: nil, category: nil, studyDescription: "느그 아부지", freeRule: "모하시노? 근달입니더. 니 오늘 쫌 맞자. 우리 동수 마이 컷네", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
        Study(id: nil, title: "무한도전", onoff: nil, category: nil, studyDescription: "보고 싶다", freeRule: "대리운전 불러어어어어 단거어어어어어어어어", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
        Study(id: nil, title: "팀피플즈", onoff: nil, category: nil, studyDescription: "우리의 스터디", freeRule: "강남역에서 종종 모여서 앱을 개발하는 스터디라고 할 수 있는 부분이 없지 않아 있다고 생각하는 부분이라고 봅니다.", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
        Study(id: nil, title: "마", onoff: nil, category: nil, studyDescription: "느그 아부지", freeRule: "모하시노? 근달입니더. 니 오늘 쫌 맞자. 우리 동수 마이 컷네", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil),
        Study(id: nil, title: "무한도전", onoff: nil, category: nil, studyDescription: "보고 싶다", freeRule: "대리운전 불러어어어어 단거어어어어어어어어", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil)]
    private var currentStudy: Study? = Study(id: 1, title: "팀피플즈", onoff: nil, category: nil, studyDescription: "우리의 스터디", freeRule: "강남역에서 종종 모여서 앱을 개발하는 스터디라고 할 수 있는 부분이 없지 않아 있다고 생각하는 부분이라고 봅니다.", po: nil, isBlocked: false, isPaused: false, generalRule: nil, startDate: nil, endDate: nil)
    private var willDropDown = false
    private var isAdmin = true
    private var willSpreadUp = false
    
    private let notificationBtn = UIButton(type: .custom)
    private let dropdownButton = UIButton(type: .system)
    private lazy var dropdownDimmingView: UIView = {
       
        let v = UIView()
        
        v.isUserInteractionEnabled = true
        let recog = UITapGestureRecognizer(target: self, action: #selector(dropdownDimmingViewDidTapped))
        v.addGestureRecognizer(recog)
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        v.isHidden = true
        
        return v
    }()
    private lazy var dropdownContainerView = UIView()
    private lazy var dropdownTableView: UITableView = {
        
        let t = UITableView()
        
        t.delegate = self
        t.dataSource = self
        t.separatorColor = UIColor.appColor(.ppsGray3)
        t.bounces = false
        t.showsVerticalScrollIndicator = false
        t.register(MainDropDownTableViewCell.self, forCellReuseIdentifier: MainDropDownTableViewCell.identifier)
        
        return t
    }()
    private lazy var createStudyButton: UIButton = {
        
        let b = UIButton()
        
        b.backgroundColor = UIColor.appColor(.brandMilky)
        b.setImage(UIImage(named: "plusCircleFill"), for: .normal)
        b.setTitle("   스터디 만들기", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 16)
        b.setTitleColor(UIColor.appColor(.keyColor1), for: .normal)
        b.isHidden = true
        
        return b
    }()
    private lazy var masterSwitch = BrandSwitch()
    private lazy var mainTableView = UITableView()
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
//    스터디 한두개일 때의 높이도 고려해야
    private lazy var dropdownHeightZero = dropdownContainerView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var dropdownHeightMax = dropdownContainerView.heightAnchor.constraint(equalToConstant: 250)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureView()
    }
    
    private func configureView(){
        
        if myStudies.isEmpty {
            view.backgroundColor = .systemBackground
            configureWhenNoStudy()
        } else {
            configureWhenStudyExist()
        }
    }
    
    // MARK: - Actions
    @objc private func notificationButtonDidTapped() {
        print(#function)
    }

    @objc private func dropdownButtonDidTapped() {
        notificationBtn.isHidden.toggle()
        masterSwitch.isHidden.toggle()
        dropdownButton.isSelected.toggle()
        toggleDropdown()
        dropdownDimmingView.isHidden.toggle()
    }
    
    @objc private func switchDidTapped(sender: BrandSwitch) {
        
        if sender.isOn {
            
            navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
            
            notificationBtn.isHidden = true
            dropdownButton.isHidden = true
            
            dropdownDimmingView.isHidden = false
            floatingButton.isHidden = false
            
        } else {
            
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.backgroundColor = .appColor(.background2)
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.background2)]
            notificationBtn.isHidden = false
            dropdownButton.isHidden = false
            
            dropdownDimmingView.isHidden = true
            floatingButton.isHidden = true
            floatingButton.isSelected = false
        }
    }
    
    @objc private func dropdownDimmingViewDidTapped() {
        notificationBtn.isHidden.toggle()
        masterSwitch.isHidden.toggle()
        dropdownButton.isSelected.toggle()
        toggleDropdown()
        dropdownDimmingView.isHidden.toggle()
    }
    
    @objc private func createStudyButtonDidTapped() {
        let creatingStudyVC = CreatingStudyViewController()
        navigationController?.pushViewController(creatingStudyVC, animated: true)
    }
    
    @objc private func floatingButtonDidTapped() {
        floatingButton.isSelected.toggle()
        
    }
    
    @objc private func spreadUpDimmingViewDidTapped() {
        floatingButton.isSelected.toggle()
    }
    
    private func configureNavigationItem() {
        notificationBtn.setImage(UIImage(named: "noti"), for: .normal)
        notificationBtn.setTitleColor(.black, for: .normal)
        notificationBtn.addTarget(self, action: #selector(notificationButtonDidTapped), for: .touchUpInside)
        notificationBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 35)
        
        guard let dropdownTitle = myStudies.first?.title else { return }
        
        dropdownButton.setTitle("\(dropdownTitle)  ", for: .normal)
        dropdownButton.setTitleColor(UIColor.appColor(.ppsGray1), for: .normal)
        dropdownButton.setTitleColor(UIColor.appColor(.ppsGray1), for: .selected)
        dropdownButton.tintColor = UIColor.appColor(.background2)
        dropdownButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        dropdownButton.setImage(UIImage(named: "dropDown")?.withTintColor(UIColor.appColor(.ppsGray1), renderingMode: .alwaysOriginal), for: .normal)
        dropdownButton.setImage(UIImage(named: "dropUp")?.withTintColor(UIColor.appColor(.ppsGray1), renderingMode: .alwaysOriginal), for: .selected)
        dropdownButton.semanticContentAttribute = .forceRightToLeft
        dropdownButton.addTarget(self, action: #selector(dropdownButtonDidTapped), for: .touchUpInside)
        
        navigationItem.title = "관리자 모드"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.background2)]
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationBtn), UIBarButtonItem(customView: dropdownButton)]
        
        if isAdmin {
            masterSwitch.addTarget(self, action: #selector(switchDidTapped), for: .valueChanged)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
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
        
        setConstraintsWhenNoStudy(studyEmptyImageView, studyEmptyLabel, createStudyButton)
    }
    
    private func configureWhenStudyExist() {
        
        view.backgroundColor = UIColor.appColor(.background2)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.register(MainFirstAnnouncementTableViewCell.self, forCellReuseIdentifier: MainFirstAnnouncementTableViewCell.identifier)
        mainTableView.register(MainSecondScheduleTableViewCell.self, forCellReuseIdentifier: MainSecondScheduleTableViewCell.identifier)
        mainTableView.register(MainThirdButtonTableViewCell.self, forCellReuseIdentifier: MainThirdButtonTableViewCell.identifier)
        mainTableView.register(MainFourthManagementTableViewCell.self, forCellReuseIdentifier: MainFourthManagementTableViewCell.identifier)
        
        mainTableView.separatorStyle = .none
        mainTableView.backgroundColor = UIColor.appColor(.background)
        mainTableView.isScrollEnabled = false
        
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(dropdownDimmingView)
        dropdownDimmingView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        //        dropdownContainer 제약 설정
        view.addSubview(dropdownContainerView)
        dropdownContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view).inset(9)
        }
        dropdownHeightMax.isActive = false
        dropdownHeightZero.isActive = true
        
        //        dropdown 제약 설정
        dropdownContainerView.addSubview(dropdownTableView)
        dropdownContainerView.addSubview(createStudyButton)
        
        dropdownTableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(dropdownContainerView)
            make.bottom.equalTo(createStudyButton.snp.top)
        }
        
        createStudyButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(dropdownContainerView)
        }
        
        view.addSubview(floatingButton)
        floatingButton.isHidden = true
        floatingButton.frame.origin = CGPoint(x: view.frame.size.width - 50 - 10, y: view.frame.size.height - 60 - 90)
    }
    
    private func toggleDropdown() {
        
        willDropDown.toggle()
        
        var indexPaths = [IndexPath]()
        var row = 0
        
        while row < myStudies.count {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
            row += 1
        }
        
        if willDropDown {
            
            dropdownHeightZero.isActive = false
            dropdownHeightMax.isActive = true
            
            dropdownTableView.insertRows(at: indexPaths, with: .top)
            
            createStudyButton.isHidden = false
            createStudyButton.setHeight(50)
            
            dropdownContainerView.layer.cornerRadius = 24
            dropdownContainerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            dropdownContainerView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            
            dropdownTableView.deleteRows(at: indexPaths, with: .top)
            
            dropdownHeightMax.isActive = false
            dropdownHeightZero.isActive = true
            
            createStudyButton.isHidden = true
            
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Setting Constraints
    private func setConstraintsWhenNoStudy(_ imageView: UIImageView, _ label: UILabel, _ button: UIButton) {
        
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
        
        switch tableView {
        case mainTableView: return 4
        case dropdownTableView: return willDropDown ? myStudies.count : 0
        case spreadUpTableView: return willSpreadUp ? 3 : 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case mainTableView:
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
        case dropdownTableView:
            guard let currentStudyID = currentStudy?.id else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MainDropDownTableViewCell.identifier) as! MainDropDownTableViewCell
            
            if currentStudyID == myStudies[indexPath.row].id {
                cell.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 249/255, alpha: 1)
            }
            
            cell.title = myStudies[indexPath.row].title!
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
