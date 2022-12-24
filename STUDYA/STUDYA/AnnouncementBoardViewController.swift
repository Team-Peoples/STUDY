//
//  AnnouncementBoardViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/19.
//

import UIKit
import SnapKit


final class AnnouncementBoardViewController: SwitchableViewController {
    // MARK: - Properties
    
    var announcements: [Announcement] = [
//        Announcement(id: nil, studyID: nil, title: "한줄짜리 타이틀명", content: "한줄짜리 공지사항의 경우", createdDate: Date()),
//        Announcement(id: nil, studyID: nil,title: "한줄짜리 타이틀명인데 좀 긴경우는 이렇게 보이고 상세페이지로 들어갔을때 이런식으로 보이는게 맞는거지", content: "두줄짜리 공지사항의 경우는\n이렇게 보이는게 맞지", createdDate: Date()),
//        Announcement(id: nil, studyID: nil,title: "핀공지 타이틀", content: "핀공지가 되어있고\n 한줄이상인데다가... 아무튼 많은 공지사항을 쓴경우 이렇게 보인다.", createdDate: Date(), isPinned: true),
//        Announcement(id: nil, studyID: nil, title: "한줄짜리 타이틀명", content: "한줄짜리 공지사항의 경우", createdDate: Date()),
//        Announcement(id: nil, studyID: nil,title: "한줄짜리 타이틀명인데 좀 긴경우는 이렇게", content: "두줄짜리 공지사항의 경우는\n 이렇게 보이는게 맞지", createdDate: Date()),
//        Announcement(id: nil, studyID: nil,title: "핀공지 타이틀", content: "핀공지가 되어있고\n 한줄이상인데다가... 아무튼 많은 공지사항을 쓴경우 이렇게 보인다.", createdDate: Date()),
//        Announcement(id: nil, studyID: nil, title: "한줄짜리 타이틀명", content: "한줄짜리 공지사항의 경우", createdDate: Date()),
//        Announcement(id: nil, studyID: nil,title: "한줄짜리 타이틀명인데 좀 긴경우는 이렇게", content: "두줄짜리 공지사항의 경우는\n 이렇게 보이는게 맞지", createdDate: Date()),
//        Announcement(id: nil, studyID: nil,title: "핀공지 타이틀", content: "핀공지가 되어있고\n 한줄이상인데다가... 아무튼 많은 공지사항을 쓴경우 이렇게 보인다.", createdDate: Date())
    ]
    
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
    
    private let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Const.screenWidth, height: 48)))
    private let titleLabel = CustomLabel(title: "공지사항", tintColor: .ppsBlack, size: 16, isBold: true)
    
    private let announcementBoardTableView = UITableView()
    private lazy var floatingButtonView = PlusButtonWithLabelContainerView(labelText: "공지추가")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = isSwitchOn ? "관리자 모드" : "스터디 이름"
        titleLabel.text = isSwitchOn ? "공지사항 관리" : "공지사항"
        
        navigationController?.navigationBar.titleTextAttributes = isSwitchOn ? [.foregroundColor: UIColor.white] : [.foregroundColor: UIColor.black]
        
        view.backgroundColor = .systemBackground
        
        configureHeaderView()
        configureTableView()
        configureEmptyView()
        configureNavigationBar()
        
        configureFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        checkAnnouncementBoardIsEmpty()
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
        
        announcementBoardTableView.register(AnnouncementBoardTableViewCell.self, forCellReuseIdentifier: "AnnouncementBoardTableViewCell")
        announcementBoardTableView.rowHeight = 147
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
    }
    
    // MARK: - Actions
    
    override func extraWorkWhenSwitchToggled() {
        
        navigationItem.title = isSwitchOn ? "관리자 모드" : "스터디 이름"
        titleLabel.text = isSwitchOn ? "공지사항 관리" : "공지사항"

        floatingButtonView.isHidden.toggle()
        
        if announcements.count >= 1 {
            let cells = announcementBoardTableView.cellsForRows(at: 0)
            let announcementBoardTableViewCells = cells.compactMap { cell in
                let cell = cell as? AnnouncementBoardTableViewCell
                return cell
            }
            announcementBoardTableViewCells.forEach { cell in
                cell.editable = isSwitchOn
            }
        }
    }
    
    @objc func floatingButtonDidTapped() {
    
        let creatingAnnouncementVC = AnnouncementViewController(task: .creating)
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

extension AnnouncementBoardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementBoardTableViewCell", for: indexPath) as? AnnouncementBoardTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        //자사용 이슈 떄문에 설정해줌.
        cell.editable = self.isSwitchOn
        
        cell.etcButtonAction = { [unowned self] in
            presentActionSheet(selected: cell, indexPath: indexPath, in: tableView)
        }

        cell.cellAction = { [unowned self] in
            let vc = AnnouncementViewController(task: .viewing)
            vc.announcement = announcements[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }

        cell.announcement = announcements[indexPath.row]
        return cell
    }
    
    func presentActionSheet(selected cell: AnnouncementBoardTableViewCell, indexPath: IndexPath, in tableView: UITableView) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let pinAction = UIAlertAction(title: "핀공지 설정", style: .default) { _ in
            guard let cells = tableView.cellsForRows(at: 0) as? [AnnouncementBoardTableViewCell] else { return }
            let pinnedCell = cells.filter { cell in cell.announcement?.isPinned == true }.first
            pinnedCell?.announcement?.isPinned = false
            
            cell.announcement?.isPinned = true
        }
        
        
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [unowned self] _ in
          
            let editingAnnouncementVC = AnnouncementViewController(task: .editing)
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

                self.announcements.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "닫기", style: .cancel)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: Const.cancel, style: .cancel)

        actionSheet.addAction(pinAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

extension AnnouncementBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
