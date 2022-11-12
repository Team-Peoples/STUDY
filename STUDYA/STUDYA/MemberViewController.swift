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
    
    let titleLabel = CustomLabel(title: "멤버 관리", tintColor: .ppsBlack, size: 16, isBold: true)
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
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
    }
    let vc = MemberBottomSheetViewController()
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else { return }
        
        sheetCoordinator = UBottomSheetCoordinator(parent: self, delegate: self)
        
        if dataSource != nil { sheetCoordinator.dataSource = dataSource! }
        
        
        
        vc.sheetCoordinator = sheetCoordinator
        
        sheetCoordinator.addSheet(vc, to: self, didContainerCreate: { container in
            let frame = self.view.frame
            let rect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
            container.layer.shadowColor = UIColor.appColor(.background).cgColor
        })
        
        sheetCoordinator.setCornerRadius(10)
    }
    
    private func configureCollectionView() {
        
        flowLayout.itemSize = CGSize(width: 96, height: 114)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 25
        
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
            
            cell.member = members[indexPath.item - 1]
            cell.heightDelegate = self
            
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
