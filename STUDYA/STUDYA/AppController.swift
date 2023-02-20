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
        UserDefaults.standard.set(false, forKey: Constant.isLoggedin)
        
        if KeyChain.read(key: Constant.accessToken) != nil {
            KeyChain.delete(key: Constant.accessToken)
        }
        
        if KeyChain.read(key: Constant.refreshToken) != nil {
            KeyChain.delete(key: Constant.refreshToken)
        }
        
        if KeyChain.read(key: Constant.userId) != nil {
            KeyChain.delete(key: Constant.userId)
        }
    }
    
    func deleteUserInformationAndLogout() {
        
        UserDefaults.standard.set(false, forKey: Constant.isLoggedin)
        NotificationCenter.default.post(name: .authStateDidChange, object: nil)
        
        if KeyChain.read(key: Constant.accessToken) != nil {
            KeyChain.delete(key: Constant.accessToken)
        }
        
        if KeyChain.read(key: Constant.refreshToken) != nil {
            KeyChain.delete(key: Constant.refreshToken)
        }
        
        if KeyChain.read(key: Constant.userId) != nil {
            KeyChain.delete(key: Constant.userId)
        }
        
        if KeyChain.read(key: Constant.isEmailCertificated) != nil {
            KeyChain.delete(key: Constant.isEmailCertificated)
        }
    
        if let _ = KeyChain.read(key: Constant.tempIsFirstSNSLogin) {
            KeyChain.delete(key: Constant.tempIsFirstSNSLogin)
        }
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: .authStateDidChange,
                                               object: nil)
    }
        
    @objc private func checkLoginIn() {
        
        if let _ = KeyChain.read(key: Constant.accessToken),
           let _ = KeyChain.read(key: Constant.refreshToken),
           let isEmailCertificated = KeyChain.read(key: Constant.isEmailCertificated),
           isEmailCertificated == "1",
           UserDefaults.standard.bool(forKey: Constant.isLoggedin) == true {
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        rootViewController = TabBarViewController()
    }

    private func routeToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC  = storyboard.instantiateViewController(withIdentifier: StudyInfoViewController.identifier) as! StudyInfoViewController
        rootViewController = UINavigationController(rootViewController: nextVC)
    }
}
