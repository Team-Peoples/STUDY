//
//  TabBarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/29.
//

import UIKit

final class TabBarViewController: UITabBarController {
    // MARK: - Properties
    var user: User? {
        didSet {
            print(user)
            configureTabbarController()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbarController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        perform(#selector(checkIfUserIsLoggedIn), with: nil, afterDelay: 1)
        checkIfUserIsLoggedIn()
    }
    
    // MARK: - Configure
    
    private func configureTabbarController() {
        
        tabBar.tintColor = .appColor(.ppsGray1)
        tabBar.backgroundColor = .systemBackground
        
        let homeViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "home-selected"), unselectedImage: #imageLiteral(resourceName: "home-unselected"), rootViewController: MainViewController(), title: "스터디")
        
        let calenderViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "calendar-selected"), unselectedImage: #imageLiteral(resourceName: "calendar-unselected"), rootViewController: CalendarViewController(), title: "캘린더")
        
        let profileViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "myPage-selected"), unselectedImage: #imageLiteral(resourceName: "myPage-unselected"), rootViewController: MyPageMainViewController(), title: "마이페이지")
        
        viewControllers = [homeViewController, calenderViewController, profileViewController]
    }
    
    private func templateNavigationController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        
        let navigation = UINavigationController(rootViewController: rootViewController)
        
        //        nav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        //        nav.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        
        navigation.tabBarItem.image = unselectedImage
        navigation.tabBarItem.selectedImage = selectedImage
        navigation.navigationBar.tintColor = .black
        navigation.title = title
    
        return navigation
    }

    // MARK: - Actions
    
    @objc func login(_ sender: Notification) {
        print(#function)
        guard let userInfo = sender.userInfo as? [String: User], let user = userInfo["user"] else { return }
        self.user = user
        NotificationCenter.default.removeObserver(self)
        self.dismiss(animated: true)
    }
    
    private func presentWelcomeVC() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: .loginSuccess, object: User.self)
        
        DispatchQueue.main.async { [weak self] in

            let welcomeVC = WelcomViewController()
            let nav = UINavigationController(rootViewController: welcomeVC)
            
            nav.modalPresentationStyle = .fullScreen
            
            self?.present(nav, animated: false, completion: nil)
        }
    }
    
   @objc private func checkIfUserIsLoggedIn() {
        if user == nil {
            presentWelcomeVC()
        } else {
            
        }
    }
    
    // MARK: - Setting Constraints
}
