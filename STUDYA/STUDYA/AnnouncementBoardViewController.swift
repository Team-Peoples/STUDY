//
//  AnnouncementBoardViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/19.
//

import UIKit
import SnapKit


final class AnnouncementBoardViewController: UIViewController {
    // MARK: - Properties
    var announcement: [Announcement] = [
        Announcement(id: nil, studyID: nil, title: "한줄짜리 타이틀명", content: "한줄짜리 공지사항의 경우", createdDate: Date()),
        Announcement(id: nil, studyID: nil,title: "한줄짜리 타이틀명인데 좀 긴경우는 이렇게", content: "두줄짜리 공지사항의 경우는\n 이렇게 보이는게 맞지", createdDate: Date()),
        Announcement(id: nil, studyID: nil,title: "핀공지 타이틀", content: "핀공지가 되어있고\n 한줄이상인데다가... 아무튼 많은 공지사항을 쓴경우 이렇게 보인다.", createdDate: Date(), isPinned: true)]
        
//    var announcement: [Announcement] = []
    
    private lazy var announcementEmptyView: UIView = {
        let v = UIView()
        let announcementEmptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 150))
        let announcementEmptyLabel = CustomLabel(title: "공지가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
        
        view.addSubview(announcementEmptyImageView)
        view.addSubview(announcementEmptyLabel)
        
        announcementEmptyImageView.backgroundColor = .lightGray
        
        setConstraints(announcementEmptyImageView, in: v)
        setConstraints(of: announcementEmptyLabel, with: announcementEmptyImageView)
        
        return v
    }()
    
    private lazy var headerView: UIView = {
        let v = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 48)))
        let lbl = CustomLabel(title: "공지사항", tintColor: .ppsBlack, size: 16, isBold: true)
        v.addSubview(lbl)
        setConstraints(of: lbl, in: v)
        return v
    }()
    
    private lazy var announcementBoardTableView = UITableView()
    private let masterSwitch = BrandSwitch()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureMasterSwitch()
        
        setConstraints(view: announcementBoardTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAnnouncementBoardIsEmpty()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Configure
    
    private func configureTableView() {
        
        view.addSubview(announcementBoardTableView)
        
        announcementBoardTableView.dataSource = self
        
        announcementBoardTableView.register(AnnouncementBoardTableViewCell.self, forCellReuseIdentifier: "Cell")
        announcementBoardTableView.rowHeight = 147
        announcementBoardTableView.separatorStyle = .none
        announcementBoardTableView.backgroundColor = .systemBackground
        announcementBoardTableView.tableHeaderView = headerView
    }
    
    private func configureMasterSwitch() {
        
        masterSwitch.addTarget(self, action: #selector(toggleMaster(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
    }
    
    // MARK: - Actions
    
    @objc private func toggleMaster(_ sender: BrandSwitch) {
        
        if sender.isOn {
            
            navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
            navigationItem.title = "관리자 모드"
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            let floatingButton: UIButton = {
                let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 26))
                let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
                
                lbl.text = "   공지 추가"
                lbl.textAlignment = .left
                lbl.layer.backgroundColor = UIColor(red: 0.208, green: 0.176, blue: 0.282, alpha: 0.5).cgColor
                lbl.layer.cornerRadius = 26 / 2
                lbl.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
                lbl.textColor = .white
                lbl.font = UIFont.systemFont(ofSize: 12)
                
                btn.backgroundColor = .black
                btn.setImage(image, for: .normal)
                btn.tintColor = .white

                btn.layer.shadowRadius = 10
                btn.layer.shadowOpacity = 0.3
                btn.layer.cornerRadius = 50 / 2
                
                btn.addSubview(lbl)
                lbl.sendSubviewToBack(btn)
                
                setConstraints(lbl, btn)
                
                return btn
            }()
            
            view.addSubview(floatingButton)
            
            floatingButton.addTarget(nil, action: #selector(floatingButtonDidTapped), for: .touchUpInside)
            floatingButton.frame.origin = CGPoint(x: view.frame.size.width - 50 - 10, y: view.frame.size.height - 60 - 90)
            if announcement.count >= 1 {
                for i in 0...announcement.count - 1 {
                    let cell = announcementBoardTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AnnouncementBoardTableViewCell
                    cell.etcButtonIsHiddenToggle()
                }
            }
        } else {
            
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationItem.title = nil
            navigationController?.navigationBar.tintColor = .black
            
            view.subviews.last?.removeFromSuperview()
            if announcement.count >= 1 {
                for i in 0...announcement.count - 1 {
                    let cell = announcementBoardTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AnnouncementBoardTableViewCell
                    cell.etcButtonIsHiddenToggle()
                }
            }
        }
    }
    
    @objc func floatingButtonDidTapped() {
        
        let creatingAnnouncementVC = AnnouncementViewController()
        creatingAnnouncementVC.isMaster = true
        modalPresentationStyle = .fullScreen
        present(creatingAnnouncementVC, animated: true)
    }
    
    private func checkAnnouncementBoardIsEmpty(){
        
        if announcement.isEmpty {

        } else {
            
        }
    }
                                                
    // MARK: - Setting Constraints
    
    private func setConstraints(view selectedView: UIView) {
        
        selectedView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setConstraints(_ announcementEmptyImageView: UIImageView, in view: UIView) {
        
        announcementEmptyImageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(150)
            make.center.equalTo(view)
        }
    }
    
    private func setConstraints(of announcementEmptyLabel: UILabel, with imageView: UIImageView) {
        
        announcementEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
    }
    
    private func setConstraints(of headerLabel: UILabel, in headerView: UIView) {
        
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.leading.equalTo(headerView).inset(30)
        }
    }
    
    private func setConstraints(_ lbl: UILabel, _ btn: UIButton) {
        
        lbl.snp.makeConstraints { make in
            make.bottom.equalTo(btn.snp.bottom)
            make.width.equalTo(80)
            make.height.equalTo(24)
            make.trailing.equalTo(btn.snp.centerX).offset(-2)
        }
    }
}

// MARK: - UITableViewDataSource

extension AnnouncementBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcement.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? AnnouncementBoardTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
    
        cell.etcAction = { [unowned self] in
    
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let pinAction = UIAlertAction(title: "핀공지 설정", style: .default)
            let editAction = UIAlertAction(title: "수정하기", style: .default) { [unowned self] _ in
                let creatingAnnouncementVC = AnnouncementViewController()
                creatingAnnouncementVC.isMaster = true
                creatingAnnouncementVC.announcement = announcement[indexPath.row]
                modalPresentationStyle = .fullScreen
                present(creatingAnnouncementVC, animated: true)
            }
            let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
                print("delete")
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            actionSheet.addAction(pinAction)
            actionSheet.addAction(editAction)
            actionSheet.addAction(deleteAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true)
        }
        
        cell.cellAction = { [unowned self] in
            let vc = AnnouncementViewController()
            vc.announcementTitleHeaderView = headerView
            vc.announcement = announcement[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.announcement = announcement[indexPath.row]
        return cell
    }
}
