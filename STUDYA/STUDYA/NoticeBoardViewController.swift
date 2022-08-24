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
    var notice: [Notice] = [Notice(title: "이공지는 제목이 들어와야하는 자리로 두줄이 넘어가게되면 생략해주어야합니다.\n이공지는 제목이 들어와야하는 자리로 두줄이 넘어가게되면 생략해주어야합니다.\n이공지는 제목이 들어와야하는 자리로 두줄이 넘어가게되면 생략해주어야합니다.\n이공지는 제목이 들어와야하는 자리로 두줄이 넘어가게되면 생략해주어야합니다.",
                                   content: "여기는 내용이 들어가야하는 자리인데 여기도 동일하게 두줄이상이면 생략해주어야하며 상세페이지로 들어가면 모든 내용이 다 보이게 됩니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. -수고하셨습니다- 공지내용이 길어질 수록 세로로 쭉 쓸 수 있으며, 스크롤이 가능해집니다. 본문에 쓴 내용이 많아 공지사항 메인에서 두 문장 이상으로 길어질 경우에도 여기서는 전부 보여집니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다. ----------------------------------------- ●공지사항 예시 입니다. ●공지사항 예시 입니다. ●공지사항 예시 입니다.",
                                   date: Date().formatted())]
    private let noticeBoardTableView = UITableView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(noticeBoardTableView)
        
        noticeBoardTableView.dataSource = self
        noticeBoardTableView.delegate = self
        noticeBoardTableView.register(NoticeBoardTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setConstraints()
        
        noticeBoardTableView.estimatedRowHeight = 137
        noticeBoardTableView.rowHeight = 137
        noticeBoardTableView.separatorStyle = .none
    }
    // MARK: - Configure
    // MARK: - Actions
    // MARK: - Setting Constraints
    
    func setConstraints() {
        noticeBoardTableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
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
        vc.notice = notice[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension Date {
    func formatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY.M.d"
        let result = dateFormatter.string(from: self)
        return result
    }
}
