//
//  TabBarViewController.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/29.
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK: - Properties
    var user: User? {
        didSet {
            configureTabbarController()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbarController()
        checkIfUserIsLoggedIn()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Configure
    
    private func configureTabbarController() {
        
        tabBar.tintColor = .appColor(.ppsGray1)
        tabBar.backgroundColor = .systemBackground
        
        let homeViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "home-selected"), unselectedImage: #imageLiteral(resourceName: "home-unselected"), rootViewController: MainViewController(), title: "스터디")
        
        let calenderViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "calendar-selected"), unselectedImage: #imageLiteral(resourceName: "calendar-unselected"), rootViewController: ViewController(), title: "캘린더")
        
        let profileViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "myPage-selected"), unselectedImage: #imageLiteral(resourceName: "myPage-unselected"), rootViewController: ViewController(), title: "마이페이지")
        
        viewControllers = [homeViewController, calenderViewController, profileViewController]
    }
    
    private func templateNavigationController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.title = title
        nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        return nav
    }

    // MARK: - Actions
    
    private func presentWelcomeVC() {
        DispatchQueue.main.async { [weak self] in

            let welcomeVC = WelcomViewController()
            let nav = UINavigationController(rootViewController: welcomeVC)
            
            nav.modalPresentationStyle = .fullScreen
            
            self?.present(nav, animated: false, completion: nil)
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        
        if user == nil {
            presentWelcomeVC()
        } else {
        }
    }
    
    // MARK: - Setting Constraints
}
