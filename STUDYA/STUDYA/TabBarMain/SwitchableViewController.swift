//
//  SwitchableViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/02.
//

import UIKit

class SwitchableViewController: UIViewController, Navigatable, SwitchStatusGivable {
    
    var isManager = false {
        didSet {
            configureNavigationBar()
        }
    }
    
    //to be fixed: isSwitchOn과 managerSwitch중 하나만 사용해서 UI 처리할 수 있는 방법 찾기
    var isSwitchOn = false {
        didSet {
            toggleNavigationBar()
//            toggleBackButtonColor()
            extraWorkWhenSwitchToggled()
        }
    }
//    private var switchStatusWhenWillAppear = false
    
    internal var syncSwitchReverse: (Bool) -> () = { sender in }
    
    private lazy var managerSwitch = BrandSwitch()

    @objc private func managerSwitchTappedAction(sender: BrandSwitch) {
        isSwitchOn = sender.isOn ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        managerSwitch.isOn = isSwitchOn
//        isSwitchOn = switchStatusWhenWillAppear
        
//        toggleNavigationBar()
//        toggleBackButtonColor()
        extraWorkWhenSwitchToggled()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        switchStatusWhenWillAppear = isSwitchOn
    }
    
//    needs override for each scene
    func extraWorkWhenSwitchToggled() {
    }
//
//    func toggleBackButtonColor() {
////        navigationController?.navigationBar.tintColor = isSwitchOn ? .appColor(.whiteLabel) : .appColor(.ppsBlack)
//    }
    
    private func toggleNavigationBar() {
        if isSwitchOn { turnOnNavigationBar() } else { turnOffNavigationBar() }
    }
    
    private func turnOnNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func turnOffNavigationBar() {
        navigationController?.navigationBar.backgroundColor = nil
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.ppsBlack)]
        navigationController?.navigationBar.tintColor = .appColor(.ppsBlack)
    }
    
    private func configureNavigationBar() {
        navigationController?.setBrandNavigation()
        
        if isManager {
            managerSwitch.addTarget(self, action: #selector(managerSwitchTappedAction), for: .valueChanged)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: managerSwitch)
        } else {
            navigationItem.setRightBarButtonItems(nil, animated: true)
        }
    }
}

extension SwitchableViewController: SwitchSyncable {
    
    func syncSwitchWith(nextVC: SwitchableViewController) {
        nextVC.isManager = self.isManager
        nextVC.isSwitchOn = isSwitchOn
        nextVC.syncSwitchReverse = { sender in
            self.isSwitchOn = nextVC.isSwitchOn
        }
//        nextVC.isManager = self.isManager
//        nextVC.switchStatusWhenWillAppear = isSwitchOn
//        nextVC.syncSwitchReverse = { sender in
//            self.switchStatusWhenWillAppear = nextVC.isSwitchOn
//        }
    }
}
