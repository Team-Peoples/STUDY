//
//  NoticeBoardViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/19.
//

import UIKit
import SnapKit

struct Notice {
    let title: String?
    let content: String?
    let date: String?
    var isPined = false
}

class NoticeBoardViewController: UIViewController {
    // MARK: - Properties
    var notice: [Notice] = [
        ]
    
    private let noticeBoardTableView = UITableView()
    private let masterSwitch = BrandSwitch()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureMasterSwitch()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkNoticeBoardIsEmpty()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Configure
    
    private func configureTableView() {
        view.addSubview(noticeBoardTableView)
        
        let headerView: UIView = {
            let v = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 48)))
            let lbl = CustomLabel(title: "공지사항", tintColor: .titleGeneral, size: 16, isBold: true)
            v.addSubview(lbl)
            setConstraints(of: lbl, in: v)
            return v
        }()
        
        noticeBoardTableView.dataSource = self
        noticeBoardTableView.delegate = self
        
        noticeBoardTableView.register(NoticeBoardTableViewCell.self, forCellReuseIdentifier: "Cell")
        noticeBoardTableView.rowHeight = 147
        noticeBoardTableView.separatorStyle = .none
        noticeBoardTableView.backgroundColor = .systemBackground
        noticeBoardTableView.tableHeaderView = headerView
    }
    
    private func configureMasterSwitch() {
        masterSwitch.addTarget(self, action: #selector(toggleMaster(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
    }
    
    // MARK: - Actions
    
    @objc private func toggleMaster(_ sender: BrandSwitch) {
        if sender.isOn {
            
            navigationController?.navigationBar.backgroundColor = .appColor(.brandDark)
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
            
        } else {
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationItem.title = nil
            navigationController?.navigationBar.tintColor = .black
            
            view.subviews.last?.removeFromSuperview()
        }
    }
    
    @objc func floatingButtonDidTapped() {
        
        let createNoticeVC = NoticeViewController()
        createNoticeVC.isMaster = true
        
        navigationController?.pushViewController(createNoticeVC, animated: true)
    }
    
    private func checkNoticeBoardIsEmpty(){
        
        if notice.isEmpty {
            
            let noticeEmptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 150))
            noticeEmptyImageView.backgroundColor = .lightGray
            let noticeEmptyLabel = CustomLabel(title: "공지가 없어요😴", tintColor: .titleGeneral, size: 20, isBold: true)
            
            view.addSubview(noticeEmptyImageView)
            view.addSubview(noticeEmptyLabel)
            
            setConstraints(noticeEmptyImageView)
            
            setConstraints(of: noticeEmptyLabel, with: noticeEmptyImageView)
        }
    }
                                                
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        noticeBoardTableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setConstraints(_ noticeEmptyImageView: UIImageView) {
        noticeEmptyImageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(150)
            make.center.equalTo(view)
        }
    }
    
    private func setConstraints(of noticeEmptyLabel: UILabel, with imageView: UIImageView) {
        
        noticeEmptyLabel.snp.makeConstraints { make in
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

extension NoticeBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NoticeBoardTableViewCell else { return UITableViewCell() }
        
        cell.notice = notice[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NoticeBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = NoticeViewController()
        
        vc.isMaster = masterSwitch.isOn
        vc.notice = notice[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Date Formatter

extension Date {
    func formatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY.M.d"
        
        let result = dateFormatter.string(from: self)
        return result
    }
}
