//
//  ToDoCollectionViewCell.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/19.
//

import UIKit
import SnapKit

final class ToDoViewModel {
    
    var allMySchedules = [Schedule]() {
        didSet {
            print("allmyschedules didset")
            self.filterSchedules(on: self.selectedDate)
        }
    }
    var selectedDate = Date().formatToString(format: .dashedFormat) {
        didSet {
            filterSchedules(on: selectedDate)
        }
    }
    var selectedDateSchedules = Observable([Schedule]())
    var numberOfRows = 0
    var error: Observable<PeoplesError>?
    
    func filterSchedules(on date: DashedDate) {
        let newlySelectedDateSchedules = allMySchedules.filter { schedule in
            return schedule.date == selectedDate
        }
        
        self.selectedDateSchedules.value = newlySelectedDateSchedules
    }
    
    func getAllMySchedules() {
        Network.shared.getAllMySchedules { result in
            switch result {
            case .success(let schedules):
                print("SUCCESS")
                self.allMySchedules = schedules
            case .failure(let error):
                print("fail")
                self.error = Observable(error)
            }
        }
    }
    
    func createMySchedule(content: String) {
        Network.shared.createMySchedule(content: content, date: selectedDate) { result in
            switch result {
            case .success(let schedules):
                print("제바아알!!")
                self.allMySchedules = schedules
            case .failure(let error):
                self.error = Observable(error)
            }
        }
    }
    
    func toggleMyScheduleStatus(scheduleID: ID) {
        Network.shared.toggleMyScheduleStatus(scheduleID: scheduleID) { result in
            switch result {
            case .success(let schedules):
                self.allMySchedules = schedules
            case .failure(let error):
                self.error = Observable(error)
            }
        }
    }
    
    func updateMySchedule(scheduleID: Int, content: String) {
        Network.shared.updateMySchedule(scheduleID: scheduleID, content: content) { result in
            switch result {
            case .success(let schedules):
                self.allMySchedules = schedules
            case .failure(let error):
                self.error = Observable(error)
            }
        }
    }
}

class ToDoCollectionViewCell: UICollectionViewCell {
//    🛑to be fixed: 바텀시트가 접힌 상태에서 테이블뷰를 맨아래까지 스크롤할 수 없음. 할일을 많이 작성해서 뷰를 꽉채울 때까지 내려가면 아래에 추가입력 셀이 자동으로 보이지 않아서 스크롤을 해서 아래로 조금 내려줘야 보임
    
    internal var viewModel: ToDoViewModel? {
        didSet {
            setBinding()
        }
    }
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
        
        addObservers()
        
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
    
    private func setBinding() {
        guard let viewModel = viewModel else { return }
        viewModel.selectedDateSchedules.bind { [weak self] selectedDateSchedules in
            guard let weakSelf = self else { return }
            
            weakSelf.viewModel?.numberOfRows = selectedDateSchedules.count
            weakSelf.tableView.reloadData()
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .mainCalenderDateTapped, object: nil, queue: nil) { noti in
            guard let dateComponents = noti.object as? DateComponents, let date = dateComponents.convertToDate()?.formatToString(format: .dashedFormat) else { return }
            
            self.viewModel?.selectedDate = date
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension ToDoCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        guard let viewModel = viewModel else { return 0 }
        let newlyCreatedCellNumber = 1
        print("🥹🥹")
        return viewModel.numberOfRows + newlyCreatedCellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemTableViewCell.identifier) as? ToDoItemTableViewCell else { return ToDoItemTableViewCell() }
        
        cell.heightCoordinator = heightCoordinator
        cell.cellDelegate = self
        
        configureCell(indexPath, cell)
        defineActionWhenTextfieldEditDone(for: cell, at: indexPath)
        
        return cell
    }
    
    private func configureCell(_ indexPath: IndexPath, _ cell: ToDoItemTableViewCell) {
//        구셀/신셀의 최초 설정 분기처리
        guard let viewModel = viewModel else { return }
        let latestOldCellRow = viewModel.selectedDateSchedules.value.count - 1
        if indexPath.row <= latestOldCellRow {
            let scheudule = viewModel.selectedDateSchedules.value[indexPath.row]
            cell.todo = scheudule.content
            cell.isDone = scheudule.status == "STOP" ? true : false
        } else {
            cell.todo = nil
            cell.isDone = false
        }
    }
    
    private func defineActionWhenTextfieldEditDone(for cell: ToDoItemTableViewCell, at indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        if indexPath.row < viewModel.numberOfRows {
            cell.numberOfRows = viewModel.numberOfRows
            cell.schedule = viewModel.selectedDateSchedules.value[indexPath.row]
            cell.updateSchedule = { (id, content) in
                viewModel.updateMySchedule(scheduleID: id, content: content)
            }
        } else {
            cell.createSchedule = { content in
                viewModel.createMySchedule(content: content)
            }
        }
        
//        guard let updateIndexPath = tableView.indexPath(for: cell) else { return }
////        셀의 텍스트필드에 문자가 있을 때 실행할 액션 정의
//        cell.textViewDidEndEditingWithLetter = { cell in
//
//            if indexPath.row == viewModel.selectedDateSchedules.value.count {
//                viewModel.createMySchedule(content: "아이아이아이")
////                self.tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .automatic)
//            } else {
////                viewModel.updateMySchedule(scheduleID: <#T##Int#>, content: <#T##String#>)
//                print("데이터 수정 후 업로드")
//            }
//        }
//
////        셀의 텍스트필드에 문자가 없을 때 실행할 액션 정의
//        cell.textViewDidEndEditingWithNoLetter = { cell in
//
//            if indexPath.row == viewModel.selectedDateSchedules.value.count {
//                print("아무것도 안함")
//            } else {
////                🛑삭제 api 요청
////                self.todo.remove(at: updateIndexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
//        }
        
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
