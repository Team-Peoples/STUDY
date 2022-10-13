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
    var backView: PassThroughView?
    
    let calendarView = UICalendarView()
    
    // MARK: - Properties
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = MyBottomSheetDataSource()
        
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.tintColor = .appColor(.keyColor1)
        
        view.addSubview(calendarView)
        view.backgroundColor = .systemBackground
        
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 2)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else { return }
        sheetCoordinator = UBottomSheetCoordinator(parent: self, delegate: self)
        
        if dataSource != nil {
            sheetCoordinator.dataSource = dataSource!
        }
        
        let vc = ScheduleViewController()
        
        vc.sheetCoordinator = sheetCoordinator
        
        sheetCoordinator.addSheet(vc, to: self, didContainerCreate: { container in
            let frame = self.view.frame
            let rect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
        })
        
        sheetCoordinator.setCornerRadius(10)
    }
    
    // MARK: - Actions
    // MARK: - Configure
    
    // MARK: - Setting Constraints
}

extension CalendarViewController: UBottomSheetCoordinatorDelegate {
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
        self.sheetCoordinator.addDropShadowIfNotExist()
        self.handleState(state)
    }
    
    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
        handleState(state)
    }
    
    func bottomSheet(_ container: UIView?, finishTranslateWith extraAnimation: @escaping ((CGFloat) -> Void) -> Void) {
        extraAnimation({ percent in
            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
        })
    }
    
    func handleState(_ state: SheetTranslationState){
        switch state {
            case .progressing(_, let percent):
                self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
            case .finished(_, let percent):
                self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
            default:
                break
        }
    }
}
