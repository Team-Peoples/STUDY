//
//  SwitchableViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/02.
//

import UIKit

class SwitchableViewController: UIViewController, Navigatable {
    
    var isManager = false {
        didSet {
            configureNavigationBar()
        }
    }
    
    //to be fixed: isSwitchOn과 managerSwitch중 하나만 사용해서 UI 처리할 수 있는 방법 찾기
    var isSwitchOn = false {
        didSet {
            toggleNavigationBar()
            toggleBackButtonColor()
            extraWorkWhenSwitchToggled()
        }
    }
    var switchStatusWhenWillAppear = false
    
    internal var syncSwitchReverse: (Bool) -> () = { sender in }
    
    private lazy var managerSwitch = BrandSwitch()

    @objc func managerSwitchTappedAction(sender: BrandSwitch) {
        isSwitchOn = sender.isOn ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        managerSwitch.isOn = switchStatusWhenWillAppear
        isSwitchOn = switchStatusWhenWillAppear
        
        toggleNavigationBar()
        toggleBackButtonColor()
        extraWorkWhenSwitchToggled()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switchStatusWhenWillAppear = isSwitchOn
    }
    
//    needs override for each scene
    func extraWorkWhenSwitchToggled() {
    }
    
    func toggleBackButtonColor() {
        navigationController?.navigationBar.tintColor = isSwitchOn ? .appColor(.whiteLabel) : .appColor(.ppsBlack)
    }
    
    func toggleNavigationBar() {
        if isSwitchOn { turnOnNavigationBar() } else { turnOffNavigationBar() }
    }
    
    func turnOnNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    func turnOffNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.ppsBlack)]
        navigationController?.navigationBar.tintColor = .appColor(.ppsBlack)
    }
    
    func configureNavigationBar() {
        navigationController?.setBrandNavigation()
        
        if isManager {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
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
        nextVC.switchStatusWhenWillAppear = isSwitchOn
        nextVC.syncSwitchReverse = { sender in
            self.switchStatusWhenWillAppear = nextVC.isSwitchOn
        }
    }
}

protocol SwitchSyncable {
    func syncSwitchWith(nextVC: SwitchableViewController)
}
