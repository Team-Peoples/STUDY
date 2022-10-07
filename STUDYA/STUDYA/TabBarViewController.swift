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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK: - Configure
    
    private func configureTabbarController() {
        
        tabBar.tintColor = .appColor(.ppsGray1)
        tabBar.backgroundColor = .systemBackground
        
        let homeViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "home-selected"), unselectedImage: #imageLiteral(resourceName: "home-unselected"), rootViewController: MainViewController(), title: "스터디")
        
        let calenderViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "calendar-selected"), unselectedImage: #imageLiteral(resourceName: "calendar-unselected"), rootViewController: AnnouncementBoardViewController(), title: "캘린더")
        
        let profileViewController = templateNavigationController(selectedImage: #imageLiteral(resourceName: "myPage-selected"), unselectedImage: #imageLiteral(resourceName: "myPage-unselected"), rootViewController: ViewController(), title: "마이페이지")
        
        viewControllers = [homeViewController, calenderViewController, profileViewController]
    }
    
    private func templateNavigationController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.title = title
        nav.navigationBar.backIndicatorImage = UIImage(named: "back")
        nav.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        return nav
    }

    // MARK: - Actions
    
    @objc func login(_ sender: Notification) {
        guard let userInfo = sender.userInfo as? [String: User], let user = userInfo["user"] else { return }
        
        self.user = user
        NotificationCenter.default.removeObserver(self)
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
    
    private func checkIfUserIsLoggedIn() {
        
//        if userdefaults의 id에 아무 값이 없다면 {
//            presentWelcomeVC()
//        } else if at,rt,id를 가지고 홈화면 데이터 통신 성공했다면 {
//            1) 완전성공
//            completion으로 받아올 데이터로 화면 구성
//            2) completion으로 받아온 User의 이메일 인증이 false라면
//            mailcheckVC 보여주기
//            3) 토큰이나 id 등 상태코드 오류가 난다면
//            presentWelcomeVC()
//        } else (response에서부터 error가 뜬다던지) {
//            presentWelcomeVC()
//        }
    }
    
    // MARK: - Setting Constraints
}
