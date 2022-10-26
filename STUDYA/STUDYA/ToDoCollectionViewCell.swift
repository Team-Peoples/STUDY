//
//  ToDoCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/19.
//

import UIKit
import SnapKit
import UBottomSheet

class ToDoCollectionViewCell: UICollectionViewCell {
//    70자 제한, 테이블뷰 셀 높이 동적할당, 텍스트뷰 입력위해 터치 시 모달 올리면서 키보드 올리기, 키보드 올라올 때 바텀 제약, 수정코자하는 셀이 중간보다 아래에 있을 때 클릭시 자동으로 키보드 바로 위로 오게, 텍스트뷰 약간 올려야할듯, 우측마진 30
    var todo = ["할일","할일2","할일3","할일4","할일5","할일6","할일7","할일8"]
    var isdone = [false,true,false,true,false,true,false,true]
    
    weak var heightDelegate: CalendarBottomSheetViewController?
    
    let tableView: UITableView = {
       
        let t = UITableView()
        
        t.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: ToDoItemTableViewCell.identifier)
        t.allowsSelection = false
        t.separatorStyle = .none
        t.backgroundColor = .appColor(.background)
//        t.estimatedRowHeight = 33
//        t.rowHeight = UITableView.automaticDimension
        
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .appColor(.background)
        
        tableView.dataSource = self
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ToDoCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todo.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemTableViewCell.identifier) as! ToDoItemTableViewCell
        
        cell.heightDelegate = heightDelegate
        
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
            let actualIndexPath = tableView.indexPath(for: cell)!
            
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
