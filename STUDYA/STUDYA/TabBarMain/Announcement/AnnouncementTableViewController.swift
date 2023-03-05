//
//  AnnouncementTableViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/19.
//

import UIKit
import SnapKit


final class AnnouncementTableViewController: SwitchableViewController {
    // MARK: - Properties
    
    let studyID: ID
    
    var announcements: [Announcement] = [] {
        didSet {
            self.announcementBoardTableView.reloadData()
            self.checkAnnouncementBoardIsEmpty()
        }
    }
    
    private lazy var announcementEmptyView: UIView = {
        let view = UIView()
        let announcementEmptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 150))
        let announcementEmptyLabel = CustomLabel(title: "공지가 없어요😴", tintColor: .ppsBlack, size: 20, isBold: true)
        
        view.addSubview(announcementEmptyImageView)
        view.addSubview(announcementEmptyLabel)
        
        announcementEmptyImageView.image = UIImage(named: "emptyViewImage")
        
        setConstraints(announcementEmptyImageView, in: view)
        setConstraints(of: announcementEmptyLabel, with: announcementEmptyImageView)
        
        view.isHidden = true
        return view
    }()
    
    private let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constant.screenWidth, height: 48)))
    private let titleLabel = CustomLabel(title: "공지사항", tintColor: .ppsBlack, size: 16, isBold: true)
    
    private let announcementBoardTableView = UITableView()
    private lazy var floatingButtonView = PlusButtonWithLabelContainerView(labelText: "공지추가")
    
    // MARK: - Life Cycle
    
    init(studyID: ID) {
        self.studyID = studyID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = isSwitchOn ? "공지사항 관리" : "공지사항"
        
        view.backgroundColor = .systemBackground
        
        configureHeaderView()
        configureTableView()
        configureEmptyView()
        
        configureFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        Network.shared.getAllAnnouncement(studyID: studyID) { result in
            switch result {
            case .success(let announcements):
                self.announcements = announcements
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    // MARK: - Configure
    
    private func configureHeaderView() {
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.leading.equalTo(headerView).inset(30)
        }
    }
    
    private func configureTableView() {
        
        view.addSubview(announcementBoardTableView)
        
        announcementBoardTableView.dataSource = self
        announcementBoardTableView.delegate = self
        
        announcementBoardTableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: AnnouncementTableViewCell.identifier)
        
        announcementBoardTableView.separatorStyle = .none
        announcementBoardTableView.backgroundColor = .systemBackground
        announcementBoardTableView.tableHeaderView = headerView
        
        announcementBoardTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureEmptyView() {
        announcementBoardTableView.addSubview(announcementEmptyView)
        
        announcementEmptyView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureFloatingButton() {
        
        view.addSubview(floatingButtonView)
        
        floatingButtonView.addTapAction(target: nil, action: #selector(floatingButtonDidTapped))
        
        floatingButtonView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.width.equalTo(102)
            make.height.equalTo(50)
        }
        
        floatingButtonView.isHidden = isSwitchOn ? false : true
    }
    
    // MARK: - Actions
    
    override func extraWorkWhenSwitchToggled() {
        
        titleLabel.text = isSwitchOn ? "공지사항 관리" : "공지사항"

        floatingButtonView.isHidden = isSwitchOn ? false : true
        
        if announcements.count >= 1 {
            let cells = announcementBoardTableView.cellsForRows(at: 0)
            let announcementBoardTableViewCells = cells.compactMap { cell in
                let cell = cell as? AnnouncementTableViewCell
                return cell
            }
            announcementBoardTableViewCells.forEach { cell in
                cell.editable = isSwitchOn
            }
        }
    }
    
    @objc func floatingButtonDidTapped() {
    
        let creatingAnnouncementVC = AnnouncementViewController(task: .creating, studyID: studyID)
        creatingAnnouncementVC.isMaster = true
        
        let navigationVC = UINavigationController(rootViewController: creatingAnnouncementVC)
        navigationVC.modalPresentationStyle = .fullScreen
        
        present(navigationVC, animated: true)
    }
    
    private func checkAnnouncementBoardIsEmpty(){
        
        announcementEmptyView.isHidden = announcements.isEmpty ? false :  true
    }
    
    // MARK: - Setting Constraints
    
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
}


// MARK: - UITableViewDataSource

extension AnnouncementTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnnouncementTableViewCell.identifier, for: indexPath) as? AnnouncementTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        //자사용 이슈 떄문에 설정해줌.
        cell.editable = self.isSwitchOn
        
        cell.etcButtonAction = { [unowned self] in
            presentActionSheet(selected: cell, indexPath: indexPath, in: tableView)
        }

        cell.cellAction = { [unowned self] in
            let vc = AnnouncementViewController(task: .viewing, studyID: studyID)
            vc.announcement = announcements[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }

        cell.announcement = announcements[indexPath.row]
        return cell
    }
    
    func presentActionSheet(selected cell: AnnouncementTableViewCell, indexPath: IndexPath, in tableView: UITableView) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let pinAction = UIAlertAction(title: "핀공지 설정", style: .default) { _ in
            guard let cells = tableView.cellsForRows(at: 0) as? [AnnouncementTableViewCell] else { return }
            let pinnedCell = cells.filter { cell in cell.announcement?.isPinned == true }.first
            pinnedCell?.announcement?.isPinned = false
            
            // domb: 아직 409에러 피드백 받아서 할게 있음. ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
            cell.announcement?.isPinned = true
            
            if let announcementID = cell.announcement?.id {
                Network.shared.updatePinnedAnnouncement(announcementID, isPinned: true) { result in
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
        
        
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [unowned self] _ in
          
            let editingAnnouncementVC = AnnouncementViewController(task: .editing, studyID: studyID)
            editingAnnouncementVC.isMaster = true
            editingAnnouncementVC.announcement = announcements[indexPath.row]
            
            let navigationVC = UINavigationController(rootViewController: editingAnnouncementVC)
            navigationVC.modalPresentationStyle = .fullScreen
            
            present(navigationVC, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            
            let alertController = UIAlertController(title: "이공지를 삭제 할까요?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "삭제", style: .destructive) {
                _ in
                if let announcementID = cell.announcement?.id {
                    Network.shared.deleteAnnouncement(announcementID) { result in
                        switch result {
                        case .success(let success):
                            print(success)
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
                self.announcements.remove(at: indexPath.row)
            }
            
            let cancelAction = UIAlertAction(title: "닫기", style: .cancel)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)

        actionSheet.addAction(pinAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

extension AnnouncementTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
