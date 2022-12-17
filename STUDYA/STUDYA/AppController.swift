//
//  AppController.swift
//  STUDYA
//
//  Created by 신동훈 on 2022/12/17.
//

import UIKit

final class AppController {
    static let shared = AppController()
    private init() {
        registerAuthStateDidChangeEvent()
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        
        checkLoginIn()
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: .authStateDidChange,
                                               object: nil)
    }
        
    @objc private func checkLoginIn() {
        let isLoggedin = UserDefaults.standard.bool(forKey: Const.isLoggedin) == true
        if isLoggedin {
            setHome()
        } else {
            KeyChain.delete(key: Const.accessToken)
            KeyChain.delete(key: Const.refreshToken)
            KeyChain.delete(key: Const.userId)
            
            routeToLogin()
        }
    }
    
    private func setHome() {
        rootViewController = UINavigationController(rootViewController: TabBarViewController())
    }

    private func routeToLogin() {
        rootViewController = UINavigationController(rootViewController: SignInViewController())
    }
}
//
//struct LoginManager {
//    static let shared = LoginManager()
//    
//    private init() {}
//    
//    func logout() {
//        KeyChain.delete(key: Const.accessToken)
//        KeyChain.delete(key: Const.refreshToken)
//        KeyChain.delete(key: Const.userId)
//        
//        UserDefaults.standard.set(false, forKey: Const.isLoggedin)
//        NotificationCenter.default.post(name: .authStateDidChange, object: nil)
//    }
//    
//    func logIn() {
//        UserDefaults.standard.set(true, forKey: Const.isLoggedin)
//        NotificationCenter.default.post(name: .authStateDidChange, object: nil)
//    }
//}
