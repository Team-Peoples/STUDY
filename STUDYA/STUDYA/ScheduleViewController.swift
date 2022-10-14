//
//  ScheduleViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import UIKit
import UBottomSheet

class ScheduleViewController: UIViewController, Draggable {
    // MARK: - Properties
    
    var sheetCoordinator: UBottomSheetCoordinator?
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    let bar: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray4
        return v
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetCoordinator?.startTracking(item: self)
    }
    
    // MARK: - Actions
    // MARK: - Configure
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(bar)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        bar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.centerX.equalTo(view)
            make.height.equalTo(5)
            make.width.equalTo(40)
        }
    }
}
