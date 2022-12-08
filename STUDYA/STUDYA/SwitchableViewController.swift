//
//  SwitchableViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/02.
//

import UIKit

class SwitchableViewController: UIViewController {
    
    var isAdmin = true
    
    //to be fixed: isSwitchOn과 managerSwitch중 하나만 사용해서 UI 처리할 수 있는 방법 찾기
    lazy var isSwitchOn = false {
        didSet {
            toggleNavigationBar()
            toggleBackButtonColor()
            extraWorkWhenSwitchToggled()
        }
    }
    internal var syncSwitchReverse: (Bool) -> () = { sender in }
    
    lazy var managerSwitch = BrandSwitch()

    @objc func managerSwitchTappedAction(sender: BrandSwitch) {
        isSwitchOn = sender.isOn ? true : false
    }

//    needs override for each scene
    func extraWorkWhenSwitchToggled() {
    }
    
    func toggleBackButtonColor() {
        navigationController?.navigationBar.tintColor = isSwitchOn ? .appColor(.whiteLabel) : .appColor(.ppsBlack)
    }
    
    func toggleNavigationBar() {
        if managerSwitch.isOn { turnOnNavigationBar() } else { turnOffNavigationBar() }
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
    
    //needs to call in every VC's viewDidLaod
    func configureNavigationBar() {
        navigationController?.setBrandNavigation()
        
        if isAdmin {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            managerSwitch.addTarget(self, action: #selector(managerSwitchTappedAction), for: .valueChanged)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: managerSwitch)
        }
    }
}

extension SwitchableViewController: SwitchSyncable {
    
    func syncSwitchWith(nextVC: SwitchableViewController) {
        nextVC.managerSwitch.isOn = managerSwitch.isOn
        nextVC.syncSwitchReverse = { sender in
            self.managerSwitch.isOn = nextVC.managerSwitch.isOn
        }
    }
}

extension SwitchableViewController: Navigatable {
    func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

protocol SwitchSyncable {
    func syncSwitchWith(nextVC: SwitchableViewController)
}
