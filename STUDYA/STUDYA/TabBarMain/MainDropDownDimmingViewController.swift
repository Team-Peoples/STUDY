//
//  MainDropDownDimmingViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/11.
//

import UIKit

final class MainDropDownDimmingViewController: UIViewController {
    internal var myStudyList = [Study]() {
        didSet {
            dropdownHeight = myStudyList.count < 5 ? dropdownContainerView.heightAnchor.constraint(equalToConstant: CGFloat(myStudyList.count * 50) + createStudyButtonHeight) : dropdownContainerView.heightAnchor.constraint(equalToConstant: 200 + createStudyButtonHeight)
        }
    }
    
    internal var currentStudy: Study?
    
    internal var studyTapped: (StudyOverall) -> () = { sender in }
    internal var newStudyCreatedConfirmTapped: (Study) -> () = { sender in }
    internal var presentCreateNewStudyVC: (UIViewController) -> () = { sender in }
    
    private var dropDownCellNumber: CGFloat {
        if myStudyList.count == 0 {
            return 0
        } else if myStudyList.count > 0, myStudyList.count < 5 {
            return CGFloat(myStudyList.count)
        } else {
            return 4
        }
    }
    private var willDropDown = false
    
    private var dropdownContainerView = UIView()
    private lazy var tableView: UITableView = {

        let t = UITableView()
        
        t.delegate = self
        t.dataSource = self
        t.separatorColor = UIColor.appColor(.ppsGray3)
        t.bounces = false
        t.showsVerticalScrollIndicator = false
        t.register(MainDropDownTableViewCell.self, forCellReuseIdentifier: MainDropDownTableViewCell.identifier)

        return t
    }()
    private lazy var dropdownDimmingViewButton = UIButton()
    private lazy var createStudyButton: UIButton = {
       
        let b = UIButton()
        
        b.backgroundColor = UIColor.appColor(.brandMilky)
        b.setImage(UIImage(named: "plus.circle.fill.purple"), for: .normal)
        b.setTitle("   스터디 만들기", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 16)
        b.setTitleColor(UIColor.appColor(.keyColor1), for: .normal)
        b.addTarget(self, action: #selector(createStudyButtonDidTapped), for: .touchUpInside)
        
        return b
    }()
    
    private lazy var dropdownHeightZero = dropdownContainerView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var dropdownHeight = dropdownContainerView.heightAnchor.constraint(equalToConstant: createStudyButtonHeight)
    private let createStudyButtonHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownDimmingViewButton.addTarget(self, action: #selector(dimmingViewTapped), for: .touchUpInside)
        
        configureDropdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
            self.view.backgroundColor = .black.withAlphaComponent(0.6)
        } completion: { finished in
            self.dropdown()
        }
    }
    
    @objc private func createStudyButtonDidTapped() {
        dismiss(animated: true) {
            let creatingStudyFormVC = CreatingStudyFormViewController()
            
            creatingStudyFormVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            
            let presentVC = UINavigationController(rootViewController: creatingStudyFormVC)
            
            presentVC.navigationBar.backIndicatorImage = UIImage(named: "back")
            presentVC.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
            presentVC.modalPresentationStyle = .fullScreen
            
            self.presentCreateNewStudyVC(presentVC)
        }
    }
    
    @objc private func dimmingViewTapped() {
        dismiss(animated: true)
    }
    
    private func configureDropdown() {
        guard !myStudyList.isEmpty else { return }
        
        view.addSubview(dropdownDimmingViewButton)
        view.addSubview(dropdownContainerView)
        
        dropdownDimmingViewButton.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        dropdownContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(130)
            make.leading.equalTo(view).inset(38)
            make.width.equalTo(206)
        }

        dropdownContainerView.addSubview(tableView)
        dropdownContainerView.addSubview(createStudyButton)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(dropdownContainerView)
            make.bottom.equalTo(createStudyButton.snp.top)
        }
        
        createStudyButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(dropdownContainerView)
        }
        
        dropdownHeight.isActive = false
        dropdownHeightZero.isActive = true
    }
    
    private func dropdown() {

        willDropDown.toggle()
        
        var indexPaths = [IndexPath]()
        var row = 0
        
        while row < myStudyList.count {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
            row += 1
        }
        
        dropdownHeightZero.isActive = false
        dropdownHeight.isActive = true
        
        tableView.insertRows(at: indexPaths, with: .top)
        
        createStudyButton.setHeight(50)
        
        dropdownContainerView.layer.cornerRadius = 24
        dropdownContainerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner)
        dropdownContainerView.clipsToBounds = true
        
        animateDropdown()
    }
    
    private func animateDropdown() {
        let tabBarView = self.tabBarController?.view
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            tabBarView == nil ? self.view.layoutIfNeeded() : tabBarView?.layoutIfNeeded()
        }
    }
}

extension MainDropDownDimmingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        willDropDown ? myStudyList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentStudyID = currentStudy?.id else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: MainDropDownTableViewCell.identifier) as! MainDropDownTableViewCell
        
        if currentStudyID == myStudyList[indexPath.row].id {
            cell.isCurrentStudy = true
        }
        cell.studyName = myStudyList[indexPath.row].studyName
        
        return cell
    }
}

extension MainDropDownDimmingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let studyID = myStudyList[indexPath.row].id else { return }
        
        Network.shared.getStudy(studyID: studyID) { result in
            
            switch result {
            case .success(let studyOverall):
                
                let currentStudyName = studyOverall.study.studyName!
                KeyChain.create(key: Constant.currentStudyName, value: currentStudyName)
                
                self.studyTapped(studyOverall)
                self.dismiss(animated: true)
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
}
