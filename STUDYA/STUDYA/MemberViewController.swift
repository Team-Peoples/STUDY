//
//  MemberViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/05.
//

import UIKit

final class MemberViewController: UIViewController {
    
    var members = [
        Member(nickName: "ehd", isManager: true, profileImage: UIImage(named: "ehd"), role: "방장"),
        Member(nickName: "ehd1", isManager: false),
        Member(nickName: "ehd2", isManager: false, profileImage: UIImage(named: "member"), role: "간수"),
        Member(nickName: "ehd3", isManager: true, role: "재소자"),
        Member(nickName: "ehd4", isManager: false, role: "판사"),
        Member(nickName: "ehd", isManager: true, profileImage: UIImage(named: "ehd"), role: "방장"),
        Member(nickName: "ehd1", isManager: false),
        Member(nickName: "ehd2", isManager: false, profileImage: UIImage(named: "member"), role: "간수"),
        Member(nickName: "ehd3", isManager: true, role: "재소자"),
        Member(nickName: "ehd4", isManager: false, role: "판사"),
        Member(nickName: "ehd", isManager: true, profileImage: UIImage(named: "ehd"), role: "방장"),
        Member(nickName: "ehd1", isManager: false),
        Member(nickName: "ehd2", isManager: false, profileImage: UIImage(named: "member"), role: "간수"),
        Member(nickName: "ehd3", isManager: true, role: "재소자"),
        Member(nickName: "ehd4", isManager: false, role: "판사"),
        Member(nickName: "ehd", isManager: true, profileImage: UIImage(named: "ehd"), role: "방장"),
        Member(nickName: "ehd1", isManager: false),
        Member(nickName: "ehd2", isManager: false, profileImage: UIImage(named: "member"), role: "간수"),
        Member(nickName: "ehd3", isManager: true, role: "재소자"),
        Member(nickName: "ehd4", isManager: false, role: "판사"),
        Member(nickName: "ehd", isManager: true, profileImage: UIImage(named: "ehd"), role: "방장"),
        Member(nickName: "ehd1", isManager: false),
        Member(nickName: "ehd2", isManager: false, profileImage: UIImage(named: "member"), role: "간수"),
        Member(nickName: "ehd3", isManager: true, role: "재소자"),
        Member(nickName: "ehd4", isManager: false, role: "판사")
    ]
    
    private let titleLabel = CustomLabel(title: "멤버 관리", tintColor: .ppsBlack, size: 16, isBold: true)
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let BottomVC = MemberBottomSheetViewController()
    private lazy var dimmingView: UIView = {
       
        let v = UIView(frame: .zero)
        
        v.backgroundColor = .init(white: 0, alpha: 0.6)
        v.isHidden = true
        v.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        v.addGestureRecognizer(recognizer)
        
        return v
    }()
    
    var sheetCoordinator: UBottomSheetCoordinator!
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        dataSource = MemberBottomSheetDataSource()
        
        
        
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
        
        view.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else { return }
        
        sheetCoordinator = UBottomSheetCoordinator(parent: self, delegate: self)
        
        if dataSource != nil { sheetCoordinator.dataSource = dataSource! }
        
        BottomVC.sheetCoordinator = sheetCoordinator
        BottomVC.tabBarHeight = tabBarController?.tabBar.frame.height
        
        sheetCoordinator.addSheet(BottomVC, to: self, didContainerCreate: { container in
            let frame = self.view.frame
            let rect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
            container.layer.shadowColor = UIColor.appColor(.background).cgColor
        })
        
        sheetCoordinator.setCornerRadius(10)
    }
    
    @objc private func dimmingViewTapped() {
        
        sheetCoordinator.setPosition(sheetCoordinator.availableHeight * 0.94, animated: true)
        dimmingView.isHidden = true
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
        members.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InviteMemberCollectionViewCell.identifier, for: indexPath) as! InviteMemberCollectionViewCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.identifier, for: indexPath) as! MemberCollectionViewCell
            
            let bottomViewHeight: CGFloat = 320
            
            cell.member = members[indexPath.item - 1]
            cell.profileViewTapped = { [self] in
                sheetCoordinator.setPosition(sheetCoordinator.availableHeight - bottomViewHeight - (tabBarController?.tabBar.frame.height ?? 83) , animated: true)
                dimmingView.isHidden = false
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

extension MemberViewController: UBottomSheetCoordinatorDelegate {
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
        self.sheetCoordinator.addDropShadowIfNotExist()
    }
}


struct Member {
    var nickName: String
    var isManager: Bool
    var profileImage: UIImage?
    var role: String?
}
