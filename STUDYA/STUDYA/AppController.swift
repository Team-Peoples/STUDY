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
            UIView.transition(with: window,
                              duration: 0.8,
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
    }
    
    func show(in window: UIWindow?) {
        self.window = window
        
        guard let window = window else  { return }
        
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        
        checkLoginIn()
    }
    
    func deleteUserInformation() {
        UserDefaults.standard.set(false, forKey: Const.isLoggedin)
        
        if KeyChain.read(key: Const.accessToken) != nil {
            KeyChain.delete(key: Const.accessToken)
        }
        
        if KeyChain.read(key: Const.refreshToken) != nil {
            KeyChain.delete(key: Const.refreshToken)
        }
        
        if KeyChain.read(key: Const.userId) != nil {
            KeyChain.delete(key: Const.userId)
        }
    }
    
    func deleteUserInformationAndLogout() {
        
        UserDefaults.standard.set(false, forKey: Const.isLoggedin)
        NotificationCenter.default.post(name: .authStateDidChange, object: nil)
        
        if KeyChain.read(key: Const.accessToken) != nil {
            KeyChain.delete(key: Const.accessToken)
        }
        
        if KeyChain.read(key: Const.refreshToken) != nil {
            KeyChain.delete(key: Const.refreshToken)
        }
        
        if KeyChain.read(key: Const.userId) != nil {
            KeyChain.delete(key: Const.userId)
        }
        
        if KeyChain.read(key: Const.isEmailCertificated) != nil {
            KeyChain.delete(key: Const.isEmailCertificated)
        }
    
        if let _ = KeyChain.read(key: Const.tempIsFirstSNSLogin) {
            KeyChain.delete(key: Const.tempIsFirstSNSLogin)
        }
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: .authStateDidChange,
                                               object: nil)
    }
        
    @objc private func checkLoginIn() {
        
        if let _ = KeyChain.read(key: Const.accessToken),
           let _ = KeyChain.read(key: Const.refreshToken),
           let isEmailCertificated = KeyChain.read(key: Const.isEmailCertificated),
           isEmailCertificated == "1",
           UserDefaults.standard.bool(forKey: Const.isLoggedin) == true {
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        rootViewController = TabBarViewController()
    }

    private func routeToLogin() {
        rootViewController = UINavigationController(rootViewController: WelcomViewController())
    }
}
