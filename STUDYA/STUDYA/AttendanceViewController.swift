//  AttendanceViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/11/19.
//

import UIKit
import MultiProgressView

final class AttendanceViewController: SwitchableViewController, BottomSheetAddable {
    
    internal var myAttendanceOverall: MyAttendanceOverall?
    internal var allUserAttendancePerday: AllUsersAttendacneForADay?
    
    private lazy var switchViewModel = SwitchObservableViewModel(switchStatus: isSwitchOn)
    
    private lazy var managerView: AttendanceManagerModeView = {
        
        let nib = UINib(nibName: "AttendanceManagerModeView", bundle: nil)
        let v = nib.instantiate(withOwner: AttendanceViewController.self).first as! AttendanceManagerModeView
        
        return v
    }()
    let userView = AttendancBasicModeView(viewer: .user)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isManager {
            managerView.delegate = self
        }
        userView.bottomSheetAddableDelegate = self
        setUpBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncSwitchReverse(isSwitchOn)
    }
    
    override func extraWorkWhenSwitchToggled() {
        switchViewModel.isSwitchOn.value.toggle()
        view = isSwitchOn ? managerView : userView
    }
    
    private func setUpBinding() {
        switchViewModel.isSwitchOn.bind { [weak self] isSwitchOn in
            guard let weakSelf = self else { return }
            weakSelf.view = isSwitchOn ? weakSelf.managerView : weakSelf.userView
        }
    }
}

struct Observable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    mutating func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}

struct SwitchObservableViewModel {
    
    var isSwitchOn: Observable<Bool>
    
    init(switchStatus: Bool) {
        isSwitchOn = Observable(switchStatus)
    }
}
