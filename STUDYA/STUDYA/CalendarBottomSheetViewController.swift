//
//  CalendarBottomSheetViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import UIKit

import SnapKit

protocol ScheduleCoordinator: AnyObject {
   
}

class CalendarBottomSheetViewController: UIViewController, Draggable {
    // MARK: - Properties
    
    internal weak var sheetCoordinator: UBottomSheetCoordinator?
    internal weak var dataSource: UBottomSheetCoordinatorDataSource?
    weak var scheduleCoordinator: ScheduleCoordinator?
    var studySchedule: [StudySchedule] = [] {
        didSet {
            let cell = collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? ScheduleCollectionViewCell
            cell?.studySchedules = studySchedule
            print(studySchedule, "❤️")
            cell?.reloadTableView()
            cell?.checkScheduleIsEmpty()
        }
    }
    
    private let style = lineTabStyle()
    
    private let bar = UIView()
    private let topScrollView = UIScrollView()
    private let collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    private let underLine = UIView()
    private lazy var leftTabButton: UIButton = tabButton(title: "할 일")
    private lazy var rightTabButton: UIButton = tabButton(title: "일정")
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sheetCoordinator?.startTracking(item: self)
    }
    
    // MARK: - Actions
    
    @objc func tabButtonTapped(_ sender: UIButton) {
        
        switch sender {
            case leftTabButton:
                underLine.snp.remakeConstraints { make in
                    make.height.equalTo(style.heightOfUnderLine)
                    make.width.equalTo(86)
                    make.bottom.equalTo(topScrollView).inset( -(style.heightOfUnderLine / 2))
                    make.centerX.equalTo(leftTabButton)
                }
                collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            case rightTabButton:
                underLine.snp.remakeConstraints { make in
                    make.height.equalTo(style.heightOfUnderLine)
                    make.width.equalTo(86)
                    make.bottom.equalTo(topScrollView).inset( -(style.heightOfUnderLine / 2))
                    make.centerX.equalTo(rightTabButton)
                }
                collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
                
                /// 탭을 눌렀을떄 스터디일정이 몇개 있는지 확인하고 화면구성
                /// 근데 맨처음에는 실행되지않음.
                /// cellForRowAt에서 코드 추가해주어서 해결.
                let cell = collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? ScheduleCollectionViewCell
                cell?.studySchedules = studySchedule
                print(studySchedule, "❤️")
                cell?.reloadTableView()
                cell?.checkScheduleIsEmpty()
                
            default:
                return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            sender.isSelected = true
            [self.leftTabButton, self.rightTabButton].filter({ button in
                button != sender
            }).forEach { button in
                button.isSelected = false
            }
        }
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        
        addBar()
        addTopScrollView()
        addContentView()
        addTabButtonAtTopScrollView()
        addUnderLine()
    }
    
    private func addBar() {
        
        view.addSubview(bar)
        
        bar.backgroundColor = .appColor(.ppsGray2)
        bar.clipsToBounds = true
        bar.layer.cornerRadius = 2
        
        bar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(6)
            make.centerX.equalTo(view)
            make.height.equalTo(4)
            make.width.equalTo(46)
        }
    }
    
    private func addTopScrollView() {
        
        view.addSubview(topScrollView)
        
        topScrollView.backgroundColor = style.topScrollViewBackgroundColor
        
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.showsVerticalScrollIndicator = false
        
        topScrollView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(18)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(style.heightOfTopScrollView)
        }
    }
    
    private func addContentView() {
        
        view.addSubview(collectionView)
        
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.bounces = false
        
        collectionView.register(ToDoCollectionViewCell.self, forCellWithReuseIdentifier: "ToDoCollectionViewCell")
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: "MyScheduleCollectionViewCell")
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topScrollView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
        }
    }
    
    private func addUnderLine() {
        
        view.addSubview(underLine)
        
        underLine.clipsToBounds = true
        underLine.layer.cornerRadius = style.heightOfUnderLine / 2
        underLine.backgroundColor = style.underLineColor
        
        underLine.snp.makeConstraints { make in
            make.height.equalTo(style.heightOfUnderLine)
            make.width.equalTo(86)
            make.bottom.equalTo(topScrollView).inset( -(style.heightOfUnderLine / 2))
            make.centerX.equalTo(leftTabButton)
        }
    }
    
    
    private func addTabButtonAtTopScrollView(){
        
        topScrollView.addSubview(leftTabButton)
        topScrollView.addSubview(rightTabButton)
        
        leftTabButton.isSelected = true
        
        leftTabButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(topScrollView)
            make.width.equalTo(view.frame.width / 2)
            make.height.equalTo(style.heightOfTopScrollView)
        }
        
        rightTabButton.snp.makeConstraints { make in
            make.leading.equalTo(leftTabButton.snp.trailing)
            make.top.trailing.bottom.equalTo(topScrollView)
            make.width.equalTo(view.frame.width / 2)
            make.height.equalTo(style.heightOfTopScrollView)
        }
    }
    
    private func tabButton(title: String) -> UIButton {
        
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .selected)
        
        button.titleLabel?.font = style.tabButtonFont
        
        button.setTitleColor(style.tabItemDefaultColor, for: .normal)
        button.setTitleColor(style.tabItemSelectedColor, for: .selected)
        
        button.addTarget(self, action: #selector(tabButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Setting Constraints
}

extension CalendarBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoCollectionViewCell", for: indexPath) as? ToDoCollectionViewCell else { return ToDoCollectionViewCell() }
            
            cell.heightCoordinator = sheetCoordinator
            cell.viewModel = ToDoViewModel()
            cell.viewModel?.getAllMySchedules()
            
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyScheduleCollectionViewCell", for: indexPath) as? ScheduleCollectionViewCell else { return ScheduleCollectionViewCell() }
            
            cell.studySchedules = studySchedule
            cell.reloadTableView()
            cell.checkScheduleIsEmpty()
            
            return cell
        default: break
        }
        
        return UICollectionViewCell()
    }
}

extension CalendarBottomSheetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

struct lineTabStyle {
    
    var heightOfTopScrollView: CGFloat = 35
    var heightOfUnderLine: CGFloat = 6
    
    var tabButtonFont = UIFont.boldSystemFont(ofSize: 16)
    
    var tabItemDefaultColor: UIColor = .gray
    var tabItemSelectedColor: UIColor = .black
    var underLineColor: UIColor = .appColor(.keyColor3)
    
    var topScrollViewBackgroundColor: UIColor = .white
}
