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
        
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        checkLoginIn()
    }
    
    func deleteUserInformation() {
        UserDefaults.standard.set(false, forKey: Constant.isLoggedin)
        KeychainService.shared.removeAll()
    }
    
    func deleteUserInformationAndLogout() {
        
        UserDefaults.standard.set(false, forKey: Constant.isLoggedin)
        NotificationCenter.default.post(name: .authStateDidChange, object: nil)
        KeychainService.shared.removeAll()
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: .authStateDidChange,
                                               object: nil)
    }
        
    @objc private func checkLoginIn() {
        
        if let _ = KeychainService.shared.read(key: Constant.accessToken),
           let _ = KeychainService.shared.read(key: Constant.refreshToken),
           let isEmailCertificated = KeychainService.shared.read(key: Constant.isEmailCertificated),
           isEmailCertificated == "1",
           UserDefaults.standard.bool(forKey: Constant.isLoggedin) == true {
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        rootViewController = TabBarViewController()
        goInviteeLanding()
    }

    private func routeToLogin() {
        deleteUserInformation()
        rootViewController = UINavigationController(rootViewController: WelcomViewController())
    }
    
    func goInviteeLanding() {
        if UserDefaults.standard.bool(forKey: Constant.isLoggedin) {
            guard let invitedStudyID = UserDefaults.standard.value(forKey: Constant.invitedStudyID) as? ID else { return }
            let inviteeLandingViewController = InviteeLandingViewController(studyID: invitedStudyID)
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
            guard let rootViewController = sceneDelegate.window?.rootViewController as? TabBarViewController else { return }
            inviteeLandingViewController.modalPresentationStyle = .fullScreen
            rootViewController.present(inviteeLandingViewController, animated: true)
            UserDefaults.standard.removeObject(forKey: Constant.invitedStudyID)
        }
    }
}
