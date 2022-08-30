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
        Notice(title: "이공지는 제목이 들어와야하는 자리로 두줄이 넘어가게되면 생략해주어야합니다.\n 이공지는 제목이 들어와야하는 자리로 두줄이 넘어가게되면 생략해주어야합니다.",
               content: "여기는 내용이 들어가야하는 자리인데 여기도 동일하게 두줄이상이면 생략해주어야하며 상세페이지로 들어가면 모든 내용이 다 보이게 됩니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.",
               date: Date().formatted()),
        Notice(title: "이공지는 제목이 들어와야하는 자리로 두줄이 넘어가게되면 생략해주어야합니다.\n 이공지는 제목이 들어와야하는 자리로 두줄이 넘어가게되면 생략해주어야합니다.",
               content: "여기는 내용이 들어가야하는 자리인데 여기도 동일하게 두줄이상이면 생략해주어야하며 상세페이지로 들어가면 모든 내용이 다 보이게 됩니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.",
               date: Date().formatted(), isPined: true),
        Notice(title: "sdfsdf", content: "sfsdf:", date: Date().formatted())]
    
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
        masterSwitch.addTarget(self, action: #selector(toggleMaster(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masterSwitch)
    }
    
    // MARK: - Actions
    
    @objc private func toggleMaster(_ sender: UISwitch) {
        if sender.isOn {
            
            navigationController?.navigationBar.backgroundColor = .appColor(.brandDark)
            navigationItem.title = "관리자 모드"
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            let floatingButton: UIButton = {
                let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
                
                btn.backgroundColor = .black
                btn.setImage(image, for: .normal)
                btn.tintColor = .white

                btn.layer.shadowRadius = 10
                btn.layer.shadowOpacity = 0.3
                btn.layer.cornerRadius = 50 / 2
                
                return btn
            }()
            
            view.addSubview(floatingButton)
            
            floatingButton.addTarget(nil, action: #selector(floatingButtonDidTapped), for: .touchUpInside)
            floatingButton.frame.origin = CGPoint(x: view.frame.size.width-50-10, y: view.frame.size.height-60-90)
            
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
            
            let noticeEmptyLabel = CustomLabel(title: "공지가 없어요😴", tintColor: .titleGeneral, size: 20, isBold: true)
            
            view.addSubview(noticeEmptyLabel)
            
            setConstraints(of: noticeEmptyLabel)
        }
    }
                                                
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        noticeBoardTableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setConstraints(of noticeEmptyLabel: UILabel) {
        
        noticeEmptyLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    private func setConstraints(of headerLabel: UILabel, in headerView: UIView) {
        
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.leading.equalTo(headerView).inset(30)
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
