//
//  CalendarBottomSheetViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import UIKit

import UBottomSheet
import SnapKit

class CalendarBottomSheetViewController: UIViewController, Draggable {
    // MARK: - Properties
    
    weak var sheetCoordinator: UBottomSheetCoordinator?
    weak var dataSource: UBottomSheetCoordinatorDataSource?
    
    private let style = lineTabStyle()
    
    private let bar = UIView()
    private let topScrollView = UIScrollView()
    private let contentView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    private let underLine = UIView()
    private lazy var leftTabButton: UIButton = {
        let btn = UIButton()
        return setupTab(button: btn, title: "할 일")
    }()
    private lazy var rightTabButton: UIButton = {
        let btn = UIButton()
        return setupTab(button: btn, title: "일정")
    }()
    
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
                contentView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            case rightTabButton:
                underLine.snp.remakeConstraints { make in
                    make.height.equalTo(style.heightOfUnderLine)
                    make.width.equalTo(86)
                    make.bottom.equalTo(topScrollView).inset( -(style.heightOfUnderLine / 2))
                    make.centerX.equalTo(rightTabButton)
                }
                contentView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
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
        
        view.addSubview(contentView)
    
        contentView.isPagingEnabled = true
        
        contentView.delegate = self
        contentView.dataSource = self
        
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        
        contentView.bounces = false
        
        contentView.register(ToDoCollectionViewCell.self, forCellWithReuseIdentifier: "ToDoCollectionViewCell")
        contentView.register(MyScheduleCollectionViewCell.self, forCellWithReuseIdentifier: "MyScheduleCollectionViewCell")
        
        contentView.snp.makeConstraints { make in
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
    
    private func setupTab(button: UIButton, title: String) -> UIButton {
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoCollectionViewCell", for: indexPath) as! ToDoCollectionViewCell
                return cell
                
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyScheduleCollectionViewCell", for: indexPath) as! MyScheduleCollectionViewCell
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

