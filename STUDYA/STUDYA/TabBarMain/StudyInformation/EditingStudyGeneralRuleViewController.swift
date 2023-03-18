//
//  EditingStudyGeneralRuleViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/12/27.
//

import UIKit

final class EditingStudyGeneralRuleViewController: UIViewController {

    // MARK: - Model
    
    var studyViewModel = StudyViewModel()
    
    // MARK: - UI Properties
    
    private let separateBar = UIView()
    private let topScrollView = UIScrollView()
    private let contentView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    private let underLine = UIView()
    private lazy var leftTabButton: UIButton = tabButton(title: "출결&벌금")
    private lazy var rightTabButton: UIButton = tabButton(title: "강퇴")
    
    private lazy var doneButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(ruleEditDone))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        configureViews()
        setConstraints()
    }

    // MARK: - Actions
    
    @objc func tabButtonTapped(_ sender: UIButton) {
        
        switch sender {
            case leftTabButton:
                underLine.snp.remakeConstraints { make in
                    make.height.equalTo(6)
                    make.width.equalTo(86)
                    make.bottom.equalTo(topScrollView).inset(-3)
                    make.centerX.equalTo(leftTabButton)
                }
                contentView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            case rightTabButton:
                underLine.snp.remakeConstraints { make in
                    make.height.equalTo(6)
                    make.width.equalTo(86)
                    make.bottom.equalTo(topScrollView).inset(-3)
                    make.centerX.equalTo(rightTabButton)
                }
                contentView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
            default:
                return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            sender.isSelected = true
            [self.leftTabButton, self.rightTabButton].filter({ button in
                button != sender
            }).forEach { button in
                button.isSelected = false
            }
        }
    }
    
    @objc func ruleEditDone() {
        
        studyViewModel.updateStudy {
            NotificationCenter.default.post(name: .studyInfoShouldUpdate, object: nil)
            self.dismiss(animated: true)
        }
    }
    
    @objc func cancel() {
        let simpleAlert = SimpleAlert(title: "작성을 중단할까요?", message: "페이지를 나가면 작성하던 내용이 사라져요.", firstActionTitle: "나가기", actionStyle: .destructive, firstActionHandler: { _ in
            self.dismiss(animated: true)
        }, cancelActionTitle: "남아있기")
        
        present(simpleAlert, animated: true)
    }
    
    // MARK: - Configure
    
    func setNavigation() {
        
        self.navigationItem.title = "규칙 관리"
        self.navigationItem.rightBarButtonItem = doneButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem?.tintColor = .appColor(.cancel)
        self.navigationItem.leftBarButtonItem?.tintColor = .appColor(.cancel)
    }
    
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        
        addTopScrollView()
        addContentView()
        addTabButtonAtTopScrollView()
        addSeparateBar()
        addUnderLine()
    }
    
    private func addTopScrollView() {
        
        view.addSubview(topScrollView)
        
        topScrollView.backgroundColor = .white
        
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.showsVerticalScrollIndicator = false
    }
    
    private func addContentView() {
        
        view.addSubview(contentView)
        
        contentView.isPagingEnabled = true
        
        contentView.delegate = self
        contentView.dataSource = self
        
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        
        contentView.bounces = false
        
        contentView.register(EditingStudyGeneralRuleAttendanceRuleCollectionViewCell.self, forCellWithReuseIdentifier: EditingStudyGeneralRuleAttendanceRuleCollectionViewCell.identifier)
        contentView.register(EditingStudyGeneralRuleExcommunicationRuleCollectionViewCell.self, forCellWithReuseIdentifier: EditingStudyGeneralRuleExcommunicationRuleCollectionViewCell.identifier)
    }
    
    private func addTabButtonAtTopScrollView(){
        
        topScrollView.addSubview(leftTabButton)
        topScrollView.addSubview(rightTabButton)
        
        leftTabButton.isSelected = true
    }
    
    private func tabButton(title: String) -> UIButton {
        
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .selected)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.setTitleColor(.appColor(.ppsGray2), for: .normal)
        button.setTitleColor(.appColor(.ppsBlack), for: .selected)
        
        button.addTarget(self, action: #selector(tabButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    private func addSeparateBar() {
        
        view.addSubview(separateBar)
        
        separateBar.backgroundColor = .appColor(.keyColor3)
        separateBar.clipsToBounds = true
        separateBar.layer.cornerRadius = 1 / 2
    }
    
    private func addUnderLine() {
        
        view.addSubview(underLine)
        
        underLine.clipsToBounds = true
        underLine.layer.cornerRadius = 6 / 2
        underLine.backgroundColor = .appColor(.keyColor3)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        topScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(41) // 또는 40
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(topScrollView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
        
        leftTabButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(topScrollView)
            make.width.equalTo(view.frame.width / 2)
            make.height.equalTo(41)
        }
        
        rightTabButton.snp.makeConstraints { make in
            make.leading.equalTo(leftTabButton.snp.trailing)
            make.top.trailing.bottom.equalTo(topScrollView)
            make.width.equalTo(view.frame.width / 2)
            make.height.equalTo(41)
        }
        
        separateBar.snp.makeConstraints { make in
            make.bottom.equalTo(topScrollView)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(1)
            make.height.equalTo(1)
        }
        
        underLine.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.width.equalTo(86)
            make.bottom.equalTo(topScrollView).inset(-3)
            make.centerX.equalTo(leftTabButton)
        }
    }
}

extension EditingStudyGeneralRuleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditingStudyGeneralRuleAttendanceRuleCollectionViewCell.identifier, for: indexPath) as? EditingStudyGeneralRuleAttendanceRuleCollectionViewCell else { return UICollectionViewCell() }
            
            cell.delegate = self
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditingStudyGeneralRuleExcommunicationRuleCollectionViewCell.identifier, for: indexPath) as? EditingStudyGeneralRuleExcommunicationRuleCollectionViewCell else { return EditingStudyGeneralRuleExcommunicationRuleCollectionViewCell() }
            
            cell.latenessCountField.text = studyViewModel.study.generalRule?.excommunication.lateness?.toString() ?? "--"
            cell.absenceCountField.text = studyViewModel.study.generalRule?.excommunication.absence?.toString() ?? "--"
            
            cell.latenessCountFieldAction = { [self] latenessCount in
                studyViewModel.study.generalRule?.excommunication.lateness = latenessCount
            }
            cell.absenceCountFieldAction = { [self] absenceCount in
                studyViewModel.study.generalRule?.excommunication.absence = absenceCount
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension EditingStudyGeneralRuleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return contentView.frame.size
    }
}
