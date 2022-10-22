//
//  ToDoCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/19.
//

import UIKit
import SnapKit

class ToDoCollectionViewCell: UICollectionViewCell {
    
    var todo = ["할일1","할일2","할일3","할일4","할일5","할일6","할일7","할일8"]
    var isdone = [false,true,false,true,false,true,false,true]
    
    let tableView: UITableView = {
       
        let t = UITableView()
        
        t.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: ToDoItemTableViewCell.identifier)
        t.allowsSelection = false
        t.separatorStyle = .none
        t.backgroundColor = .appColor(.background)
        
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .appColor(.background)
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        
        
//        구셀/신셀의 최초 설정 분기처리
        if indexPath.row <= todo.count - 1 {
            cell.todo = todo[indexPath.row]
            cell.isDone = isdone[indexPath.row]
        } else {
            cell.todo = nil
            cell.isDone = false
        }
        
//        셀의 텍스트필드에 문자가 있을 때 실행할 액션 정의
        cell.fieldDidEndEditingWithLetter = { cell in
            let actualIndexPath = tableView.indexPath(for: cell)!
            
            if actualIndexPath.row == self.todo.count {
                self.isdone.append(cell.checkButton.isSelected)
                self.todo.append(cell.todoField.text!)
                self.tableView.insertRows(at: [IndexPath(row: actualIndexPath.row + 1, section: 0)], with: .automatic)
            } else {
                print("데이터 수정 후 업로드")
            }
        }
//        셀의 텍스트필드에 문자가 없을 때 실행할 액션 정의
        cell.fieldDidEndEditingWithNoLetter = { cell in
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
        33
    }
}

extension ToDoCollectionViewCell: UITableViewDelegate {
    
}
