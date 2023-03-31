//
//  MemberViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/05.
//

import UIKit
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon


final class MemberViewController: SwitchableViewController, BottomSheetAddable {
    
    internal var currentStudyID: Int?
    internal var members: Members?
    internal var isOwner: Bool?
    private var nowLookingMemberID: ID?
    
    private let titleLabel = CustomLabel(title: "멤버", tintColor: .ppsBlack, size: 16, isBold: true)
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    private lazy var memberBottomVC: MemberBottomSheetViewController = {
        let vc = MemberBottomSheetViewController()

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
                    vc.present(alert, animated: true)
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
                            forceSwitchStatus(isOn: false)
                            NotificationCenter.default.post(name: .reloadCurrentStudy, object: nil)
                            self.pop()
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
    lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureViews()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    private func getMemberList(studyID: ID) {
        Network.shared.getAllMembers(studyID: studyID) { result in
            switch result {
            case .success(let response):
                self.members = response.memberList
                self.isOwner = response.isUserOwner
                self.collectionView.reloadData()
                
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
                self.collectionView.reloadData()
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    internal func configureView(with studyID: ID) {
        self.currentStudyID = studyID
        getMemberList(studyID: studyID)
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
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.equalTo(50)
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
            
            cell.inviteButtonAction = { [weak self] in
                guard let view = self?.view else { return }
                
               
                self?.activityIndicator.startAnimating()
                
                guard let nickname = KeyChain.read(key: Constant.nickname) else { return }
                guard let studyName = KeyChain.read(key: Constant.currentStudyName) else { return }
                guard let currentStudyRawData = UserDefaults.standard.object(forKey: Constant.currentStudy) as? Data else { return }
                guard let currentStudy = try? JSONDecoder().decode(Study.self, from: currentStudyRawData) else { return }

                let memberCount = self?.members?.count ?? 0 + 1

                DynamicLinkBuilder().getURL(study: currentStudy, memberCount: memberCount) { dynamicLinkURL, array, error in
                    guard let link = dynamicLinkURL?.absoluteString else {
                        print("Failed to generate dynamic link URL: \(error?.localizedDescription ?? "unknown error")")
                        return
                    }
                    
                    let shareText = """
                            "\(nickname)"님이 \(studyName)에 초대했어요!
                            
                            아래 링크를 통해 스터디에
                            참여하실 수 있어요 👇🏼
                            
                            참여 링크: "\(link)"
                            
                            어떤 모임이든! 피플즈에서 쉽게 모이고 간편하게 관리해요 📚
                            """
                    let image = UIImage(named: "logo")!
                    print(image)
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        
                        let activityViewController = UIActivityViewController(activityItems : [shareText, image], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = view
                        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                        activityViewController.popoverPresentationController?.permittedArrowDirections = []

                        self?.present(activityViewController, animated: true, completion: nil)

                    }
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.identifier, for: indexPath) as! MemberCollectionViewCell
            
            guard let members = members else { return MemberCollectionViewCell() }
            
            cell.configureCell(with: members[indexPath.item - 1])
            
            cell.profileViewTapped = { [self] member in
                
                let isSwitchOn = UserDefaults.standard.bool(forKey: Constant.isSwitchOn)
                
                if isSwitchOn {
                    guard let isOwner = isOwner else { return }
                    
                    self.nowLookingMemberID = member.memberID
                    memberBottomVC.configureViewControllerWith(member: member, isOwner: isOwner)
                    
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
