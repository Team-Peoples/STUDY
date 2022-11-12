//
//  MemberBottomSheetViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/12.
//

import UIKit

final class MemberBottomSheetViewController: UIViewController, Draggable {
    
    internal weak var sheetCoordinator: UBottomSheetCoordinator?
    internal weak var dataSource: UBottomSheetCoordinatorDataSource?
    
    private let bar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sheetCoordinator?.startTracking(item: self)
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
}
