//
//  SwitchableViewController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/02.
//

import UIKit

class SwitchableViewController: UIViewController, Navigatable {
    
    var isManager = false { didSet { changeBarButton(by: isManager) } }

    private var isSwitchOn: Bool = false {
        didSet {
            toggleNavigationBar(by: isSwitchOn)
            extraWorkWhenSwitchToggled(isOn: isSwitchOn)
        }
    }
    
    private lazy var managerSwitch = BrandSwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        navigationController?.setBrandNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isSwitchOn = UserDefaults.standard.bool(forKey: Constant.isSwitchOn)
        
        self.isSwitchOn = isSwitchOn
        self.managerSwitch.isOn = isSwitchOn
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print(#function)
    }
    
    //    needs override for each scene
    func extraWorkWhenSwitchToggled(isOn: Bool) {
    }
    
    @objc private func managerSwitchTappedAction(sender: BrandSwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constant.isSwitchOn)
        isSwitchOn = sender.isOn
    }
    
    private func changeBarButton(by isOn: Bool) {
        if isOn {
            managerSwitch.addTarget(self, action: #selector(managerSwitchTappedAction), for: .valueChanged)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: managerSwitch)
        } else {
            navigationItem.setRightBarButtonItems(nil, animated: true)
        }
    }
    
    private func toggleNavigationBar(by isOn: Bool) {
        if isOn { turnOnNavigationBar() } else { turnOffNavigationBar() }
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
}

extension SwitchableViewController: Managable {

    func syncManager(with nextVC: SwitchableViewController) {
        nextVC.isManager = self.isManager
    }
}
