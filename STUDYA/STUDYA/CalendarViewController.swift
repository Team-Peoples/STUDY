//
//  CalendarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import UIKit

@available(iOS 16.0, *)
class CalendarViewController: UIViewController {
    // MARK: - Properties
    
    var sheetCoordinator: UBottomSheetCoordinator!
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    let calendarView = PeoplesCalendarView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = CalendarBottomSheetDatasource()
        title = "나의 캘린더"
        
        configureViews()
        setConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else { return }
        
        sheetCoordinator = UBottomSheetCoordinator(parent: self, delegate: self)
        
        if dataSource != nil { sheetCoordinator.dataSource = dataSource! }
        
        let vc = CalendarBottomSheetViewController()
        
        vc.sheetCoordinator = sheetCoordinator
        
        sheetCoordinator.addSheet(vc, to: self, didContainerCreate: { container in
            let frame = self.view.frame
            let rect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
            container.layer.shadowColor = UIColor.appColor(.background).cgColor
        })
        
        sheetCoordinator.setCornerRadius(10)
    }
    
    // MARK: - Actions

    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(calendarView)
    }
    
    // MARK: - Setting Constraints
    
    private func setConstraints() {
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)
        }
    }
}

extension CalendarViewController: UBottomSheetCoordinatorDelegate {
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
        self.sheetCoordinator.addDropShadowIfNotExist()
    }
}
