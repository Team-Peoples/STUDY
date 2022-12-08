//
//  SwitchableViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/02.
//

import UIKit

class SwitchableViewController: UIViewController, Navigatable {
    
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
        navigationController?.navigationBar.backIndicatorImage = isSwitchOn ? UIImage(named: "back")?.withTintColor(.white) : UIImage(named: "back")
    }
    
    func toggleNavigationBar() {
        if managerSwitch.isOn { turnOnNavigationBar() } else { turnOffNavigationBar() }
    }
    
    func turnOnNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .appColor(.keyColor1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func turnOffNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.background2)]
        navigationController?.navigationBar.tintColor = .appColor(.ppsBlack)
    }
    
//    needs to call in every VC's viewDidLaod
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if isAdmin {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.background2)]
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

protocol SwitchSyncable {
    func syncSwitchWith(nextVC: SwitchableViewController)
}
