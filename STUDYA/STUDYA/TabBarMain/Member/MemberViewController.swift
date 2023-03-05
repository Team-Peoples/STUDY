//
//  MemberViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/05.
//

import UIKit

final class MemberViewController: SwitchableViewController, BottomSheetAddable {
    
    internal var currentStudyID: Int? {
        didSet {
            guard let currentStudyID = currentStudyID else { return }
            getMemberList(studyID: currentStudyID)
        }
    }    
    internal var members: Members? {
        didSet {
            collectionView.reloadData()
        }
    }
    internal var isOwner: Bool?
    private var nowLookingMemberID: ID?
    
    private let titleLabel = CustomLabel(title: "멤버", tintColor: .ppsBlack, size: 16, isBold: true)
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    private lazy var memberBottomVC: MemberBottomSheetViewController = {
        let vc = MemberBottomSheetViewController()

        vc.isOwner = isOwner
        vc.askExcommunicateMember = {
            vc.dismiss(animated: true) { [self] in
                presentBottomSheet(vc: askExcommunicationVC, detent: 300, prefersGrabberVisible: false)
            }
        }
        vc.askChangeOwner = {
            vc.dismiss(animated: true) { [self] in
                presentBottomSheet(vc: askChangingOwnerVC, detent: 300, prefersGrabberVisible: false)
            }
        }
        vc.getMemberListAgainAndReload = {
            self.getMemberListAndReload()
        }
        
        return vc
    }()
    private lazy var askExcommunicationVC: AskExcommunicationViewController = {
       
        let vc = AskExcommunicationViewController()
        
        vc.navigatableDelegate = self
        
        vc.backButtonTapped = {
            vc.dismiss(animated: true) { [self] in
                presentBottomSheet(vc: memberBottomVC, detent: 300, prefersGrabberVisible: true)
            }
        }

        vc.excommunicateMember = { [self] in
            guard let nowLookingMemberID = nowLookingMemberID else { return }
            Network.shared.excommunicateMember(nowLookingMemberID) { result in
                
                switch result {
                case .success(let isSuccess):
                    if isSuccess {
                        vc.dismiss(animated: true) {
                            self.getMemberListAndReload()
                        }
                        
                    } else {
                        let alert = SimpleAlert(message: Constant.serverErrorMessage)
                        self.present(alert, animated: true)
                    }
                    
                    
                case .failure(let error):
                    var alert = SimpleAlert(message: "")
                    switch error {
                    case .cantExpelOwner:
                        alert = SimpleAlert(message: "스터디장은 강퇴할 수 없습니다.")
                    case .cantExpelSelf:
                        alert = SimpleAlert(message: "스스로를 강퇴할 수 없습니다.\n'스터디정보 - 회원탈퇴'를 통해 탈퇴해주세요.")
                    case .unauthorizedMember:
                        alert = SimpleAlert(message: "강퇴 권한이 없는 멤버입니다.")
                    default:
                        UIAlertController.handleCommonErros(presenter: self, error: error)
                    }
                }
            }
        }
        
        return vc
    }()
    private lazy var askChangingOwnerVC: AskChangingOwnerViewController = {
       
        let vc = AskChangingOwnerViewController()
        
        vc.backButtonTapped = {
            vc.dismiss(animated: true) { [self] in
                presentBottomSheet(vc: memberBottomVC, detent: 300, prefersGrabberVisible: true)
            }
        }
        vc.turnOverStudyOwnerAndReload = { [self] in
            guard let nowLookingMemberID = nowLookingMemberID else { return }
            
            Network.shared.turnOverStudyOwnerTo(memberID: nowLookingMemberID) { result in
                
                switch result {
                case .success(let isSuccess):
                    
                    if isSuccess {
                        vc.dismiss(animated: true) {
                            self.getMemberListAndReload()
                        }
                        
                    } else {
                        let alert = SimpleAlert(message: Constant.serverErrorMessage)
                        self.present(alert, animated: true)
                    }
                    
                case .failure(let error):
                    
                    switch error {
                        
                    case .youAreNotOwner:
                        let alert = SimpleAlert(message: "스터디장이 아니어서 스터디권한을 넘길 수 없습니다.")
                        self.present(alert, animated: true)
                        
                    default:
                        UIAlertController.handleCommonErros(presenter: self, error: error)
                    }
                }
            }
        }
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        navigationController?.setBrandNavigation()
//        configureNavigationBar()
//        navigationController?.title = "요시"
//        navigationItem.title = isSwitchOn ? "관리자 모드" : "스터디 이름"
        configureViews()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    @objc private func dimmingViewTapped() {
        print(#function)
    }
    
    private func getMemberList(studyID: ID) {
        Network.shared.getAllMembers(studyID: studyID) { result in
            switch result {
            case .success(let response):
                
                self.members = response.memberList
                self.isOwner = response.isUserOwner
                
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func getMemberListAndReload() {
        guard let currentStudyID = self.currentStudyID else { return }
        
        Network.shared.getAllMembers(studyID: currentStudyID) { result in
            switch result {
            case .success(let response):
                self.members = response.memberList
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func configureViews() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(14)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
        }
    }
    
    private func configureCollectionView() {
        
        flowLayout.itemSize = CGSize(width: 96, height: 114)
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
        
        collectionView.register(InviteMemberCollectionViewCell.self, forCellWithReuseIdentifier: InviteMemberCollectionViewCell.identifier)
        collectionView.register(MemberCollectionViewCell.self, forCellWithReuseIdentifier: MemberCollectionViewCell.identifier)
    }
}

extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let members = members else { return 0 }
        
        return members.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InviteMemberCollectionViewCell.identifier, for: indexPath) as! InviteMemberCollectionViewCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.identifier, for: indexPath) as! MemberCollectionViewCell
            
            guard let members = members else { return MemberCollectionViewCell() }
            
            cell.member = members[indexPath.item - 1]
            cell.switchObservableDelegate = self
            
            if isSwitchOn { //🛑여기 isManager 아니겠지?
                cell.profileViewTapped = { [self] member in
                    
                    self.nowLookingMemberID = member.memberID
                    memberBottomVC.member = member
                    
                    presentBottomSheet(vc: memberBottomVC, detent: 300, prefersGrabberVisible: true)
                }
            }
            
            return cell
        }
    }
}

extension MemberViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function )
    }
}
