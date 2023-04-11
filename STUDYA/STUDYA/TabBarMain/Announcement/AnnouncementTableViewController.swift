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
    let studyName: String
    var announcements: [Announcement] = [] {
        didSet {
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
        
        return view
    }()
    
    private let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constant.screenWidth, height: 48)))
    private let titleLabel = CustomLabel(title: "공지사항", tintColor: .ppsBlack, size: 16, isBold: true)
    
    private let announcementBoardTableView = UITableView()
    private lazy var floatingButtonView = PlusButtonWithLabelContainerView(labelText: "공지추가")
    
    // MARK: - Life Cycle
    
    init(studyID: ID, studyName: String) {
        self.studyID = studyID
        self.studyName = studyName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = studyName
        view.backgroundColor = .white
        
        configureHeaderView()
        configureTableView()
        
        configureFloatingButton()
        fetchAnnouncement()
        
        NotificationCenter.default.addObserver(forName: .updateAnnouncement, object: nil, queue: nil) { noti in
            self.refresh()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
        
        announcementBoardTableView.refreshControl = UIRefreshControl()
        
        announcementBoardTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        announcementBoardTableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: AnnouncementTableViewCell.identifier)
        
        announcementBoardTableView.separatorStyle = .none
        announcementBoardTableView.backgroundColor = .white
        announcementBoardTableView.tableHeaderView = headerView
        
        announcementBoardTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureEmptyView() {
        announcementBoardTableView.addSubview(announcementEmptyView)
        
        announcementEmptyView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(announcementBoardTableView.safeAreaLayoutGuide)
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
        
        let isSwitchOn = UserDefaults.standard.bool(forKey: Constant.isSwitchOn)
        
        floatingButtonView.isHidden = !isSwitchOn
    }
    
    // MARK: - Actions
    
    override func extraWorkWhenSwitchToggled(isOn: Bool) {
        
        titleLabel.text = isOn ? "공지사항 관리" : "공지사항"
        
        floatingButtonView.isHidden = isOn ? false : true
        
        if announcements.count >= 1 {
            let cells = announcementBoardTableView.cellsForRows(at: 0)
            let announcementBoardTableViewCells = cells.compactMap { cell in
                let cell = cell as? AnnouncementTableViewCell
                return cell
            }
            announcementBoardTableViewCells.forEach { cell in
                cell.editable = isOn
            }
        }
    }
    
    @objc private func refresh() {
        fetchAnnouncement()
    }
    
    @objc func floatingButtonDidTapped() {
        
        let creatingAnnouncementVC = AnnouncementViewController(task: .creating, studyID: studyID)
        creatingAnnouncementVC.isMaster = true
        
        let navigationVC = UINavigationController(rootViewController: creatingAnnouncementVC)
        navigationVC.modalPresentationStyle = .fullScreen
        
        present(navigationVC, animated: true)
    }
    
    @objc private func fetchAnnouncement() {
        Network.shared.getAllAnnouncement(studyID: studyID) { [weak self] result in
            switch result {
            case .success(let announcements):
                let sortedAnnouncements = announcements.sorted { $0.createdDate > $1.createdDate
                }
                self?.announcements = sortedAnnouncements
                self?.announcementBoardTableView.refreshControl?.endRefreshing()
            case .failure(let error):
                UIAlertController.handleCommonErros(presenter: self, error: error)
            }
        }
    }
    
    private func updatePin(announcement announcementID: ID, isPinned: Bool, successHandler: @escaping () -> Void) {
        
        Network.shared.updatePinnedAnnouncement(announcementID, isPinned: isPinned
        ) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .reloadCurrentStudy, object: nil)
                successHandler()
            case .failure:
                let simpleAlert = SimpleAlert(buttonTitle: Constant.OK, message: "핀공지 설정에 실패했어요.\n잠시후 다시 시도해주세요.", completion: nil)
                self.present(simpleAlert)
            }
        }
    }
    
    private func forcingUpdatePin(announcement announcementID: ID, successHandler: @escaping () -> Void) {
        Network.shared.forcingUpdatePinnedAnnouncement(announcementID) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .reloadCurrentStudy, object: nil)
                successHandler()
            case .failure(let failure):
                let simpleAlert = SimpleAlert(buttonTitle: Constant.OK, message: "핀공지 설정에 실패했어요.\n잠시후 다시 시도해주세요.", completion: nil)
                self.present(simpleAlert)
                print(failure)
            }
        }
    }
    private func checkAnnouncementBoardIsEmpty(){
        
        if announcements.isEmpty {
            configureEmptyView()
        } else {
            announcementEmptyView.removeFromSuperview()
        }
        
        announcementBoardTableView.reloadData()
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
        
        let isSwitchOn = UserDefaults.standard.bool(forKey: Constant.isSwitchOn)
        cell.editable = isSwitchOn
        
        cell.etcButtonAction = { [weak self] in
            self?.presentActionSheet(selected: cell, indexPath: indexPath, in: tableView)
        }
        
        cell.cellAction = { [weak self] in
            guard let studyID = self?.studyID else { return }
            let vc = AnnouncementViewController(task: .viewing, studyID: studyID, studyName: self?.studyName)
            vc.announcement = self?.announcements[indexPath.row]
            vc.title = self?.studyName
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.announcement = announcements[indexPath.row]
        return cell
    }
    
    func presentActionSheet(selected cell: AnnouncementTableViewCell, indexPath: IndexPath, in tableView: UITableView) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let announcementAlreadyPinned = cell.isPinned == true
        
        if announcementAlreadyPinned {
            // 핀공지 해제
            let pinAction = UIAlertAction(title: "핀공지 해제", style: .default) { [weak  self] _ in
                guard let announcementID = cell.announcement?.id else { return }
                self?.updatePin(announcement: announcementID, isPinned: false) { [weak self] in
                    self?.refresh()
                }
            }
            actionSheet.addAction(pinAction)
        } else {
            let pinAction = UIAlertAction(title: "핀공지 설정", style: .default) { [weak self] _ in
                guard let announcementID = cell.announcement?.id else { return }
                
                self?.forcingUpdatePin(announcement: announcementID, successHandler: {
                    self?.refresh()
                })
            }
            actionSheet.addAction(pinAction)
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
            let alertController = SimpleAlert(title: "이 공지를 삭제 할까요?", message: "삭제하면 되돌릴 수 없습니다.", firstActionTitle: Constant.delete, actionStyle: .destructive, firstActionHandler: { [weak self] _ in
                if let announcementID = cell.announcement?.id {
                    Network.shared.deleteAnnouncement(announcementID) { result in
                        switch result {
                        case .success:
                            self?.refresh()
                        case .failure(let error):
                            guard let weakSelf = self else { return }
                            UIAlertController.handleCommonErros(presenter: weakSelf, error: error)
                        }
                    }
                }
            }, cancelActionTitle: Constant.cancel)
            
            self.present(alertController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(actionSheet, animated: true, completion: nil)
            }
        } else {
            self.present(actionSheet, animated: true, completion: nil)
        }
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
