//
//  ToDoCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/19.
//

import UIKit
import SnapKit

class ToDoCollectionViewCell: UICollectionViewCell {
//    🛑to be fixed: 바텀시트가 접힌 상태에서 테이블뷰를 맨아래까지 스크롤할 수 없음. 할일을 많이 작성해서 뷰를 꽉채울 때까지 내려가면 아래에 추가입력 셀이 자동으로 보이지 않아서 스크롤을 해서 아래로 조금 내려줘야 보임
    var todo = ["할일","할일2","할일3","할일4","할일5","할일6","할일7","할일8"]
    var isdone = [false,true,false,true,false,true,false,true]
    
    weak var heightCoordinator: UBottomSheetCoordinator?
    
    let tableView: UITableView = {
       
        let t = UITableView()
        
        t.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: ToDoItemTableViewCell.identifier)
        t.allowsSelection = false
        t.separatorStyle = .none
        t.backgroundColor = .appColor(.background)
        t.showsVerticalScrollIndicator = false
//        t.estimatedRowHeight = 33
//        t.rowHeight = UITableView.automaticDimension
        
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.backgroundColor = .appColor(.background)
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

extension ToDoCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todo.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemTableViewCell.identifier) as! ToDoItemTableViewCell
        
        cell.heightCoordinator = heightCoordinator
        
        cell.cellDelegate = self
//        구셀/신셀의 최초 설정 분기처리
        if indexPath.row <= todo.count - 1 {
            cell.todo = todo[indexPath.row]
            cell.isDone = isdone[indexPath.row]
        } else {
            cell.todo = nil
            cell.isDone = false
        }
        
//        셀의 텍스트필드에 문자가 있을 때 실행할 액션 정의
        cell.textViewDidEndEditingWithLetter = { cell in
            guard let actualIndexPath = tableView.indexPath(for: cell) else { return }
            
            if actualIndexPath.row == self.todo.count {
                self.isdone.append(cell.checkButton.isSelected)
                self.todo.append(cell.todoTextView.text!)
                self.tableView.insertRows(at: [IndexPath(row: actualIndexPath.row + 1, section: 0)], with: .automatic)
            } else {
                print("데이터 수정 후 업로드")
            }
        }
//        셀의 텍스트필드에 문자가 없을 때 실행할 액션 정의
        cell.textViewDidEndEditingWithNoLetter = { cell in
            let actualIndexPath = tableView.indexPath(for: cell)!
            
            if actualIndexPath.row == self.todo.count {
                print("아무것도 안함")
            } else {
                self.todo.remove(at: actualIndexPath.row)
                tableView.deleteRows(at: [actualIndexPath], with: .automatic)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33   //🛑폰트 크기 바뀌면 여기도 바꿔야
    }
}

extension ToDoCollectionViewCell: GrowingCellProtocol {

    func updateHeightOfRow(_ cell: ToDoItemTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
