//
//  MemberViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/05.
//

import UIKit

final class MemberViewController: SwitchableViewController, SwitchStatusGivable, BottomSheetAddable {
    
    internal var members: Members? {
        didSet {
            collectionView.reloadData()
        }
    }
    internal var isOwner: Bool?
    internal var currentStudyID: Int?
    private var nowLookingMemberID: ID?
    
    private let titleLabel = CustomLabel(title: "멤버", tintColor: .ppsBlack, size: 16, isBold: true)
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    private lazy var memberBottomVC: MemberBottomSheetViewController = {
        let vc = MemberBottomSheetViewController()

        vc.isOwner = isOwner
        vc.askExcommunicateMember = {
            vc.dismiss(animated: true) { [self] in
                askExcommunicationVC.excommunicatedMemberID = nowLookingMemberID
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
        vc.getMemberListAgainAndReload = {
            self.getMemberListAndReload()
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
        vc.getMemberListAgainAndReload = {
            self.getMemberListAndReload()
        }
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        
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
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        members = [Member(memberID: 0, deposit: 0, nickName: "쥔", profileImageURL: nil, role: "쥔장", isManager: true, isOwner: true),
//                   Member(memberID: 0, deposit: 0, nickName: "매님", profileImageURL: nil, role: "매님", isManager: true, isOwner: false),
//                   Member(memberID: 0, deposit: 0, nickName: "평", profileImageURL: nil, role: "평민", isManager: false, isOwner: false),
//                   Member(memberID: 0, deposit: 0, nickName: "쩌리", profileImageURL: nil, role: nil, isManager: false, isOwner: false)]
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    @objc private func dimmingViewTapped() {
        print(#function)
    }
    
    private func getMemberListAndReload() {
        guard let currentStudyID = self.currentStudyID else { return }
        
        Network.shared.getAllMembers(studyID: currentStudyID) { result in
            switch result {
            case .success(let response):
                self.members = response.memberList
            case .failure(let error):
                print(#function)
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
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
            
            if isManager {
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

struct MemberListResponse: Codable {
    let memberList: [Member]
    let isUserManager: Bool
    let isUserOwner: Bool
    
    enum CodingKeys: String, CodingKey {
        case memberList
        case isUserManager = "manager"
        case isUserOwner = "master"
    }
}

struct Member: Codable {
    let memberID, deposit: Int
    let nickName, profileImageURL, role: String?
    let isManager: Bool
//    let isOwner: Bool

    enum CodingKeys: String, CodingKey {
        case memberID = "studyMemberId"
        case nickName = "userNickname"
        case profileImageURL = "img"
        case isManager = "userManager"
//        case isOwner = "userMaster"
        case role = "userRole"
        case deposit
    }
}

typealias Members = [Member]
