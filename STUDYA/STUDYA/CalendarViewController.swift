//
//  CalendarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/10/13.
//

import UIKit
import UBottomSheet

@available(iOS 16.0, *)
class CalendarViewController: UIViewController {
    // MARK: - Properties
    
    var sheetCoordinator: UBottomSheetCoordinator!
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    let calendarView: UICalendarView = {
        let c = UICalendarView()
        
        c.calendar = Calendar(identifier: .gregorian)
        c.tintColor = .appColor(.keyColor1)
        
        return c
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = MyBottomSheetDataSource()
        title = "나의 캘린더"
        
        configureViews()
        setConstraints()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(navibarTapped))
        navigationController?.navigationBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.addGestureRecognizer(recognizer)
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
    
    @objc private func navibarTapped() {
        view.endEditing(true)
        sheetCoordinator.setPosition(844 * 0.6, animated: true)
    }
    
    // MARK: - Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
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
