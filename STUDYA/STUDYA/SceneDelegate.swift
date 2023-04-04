//
//  SceneDelegate.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit
import KakaoSDKAuth
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // open url
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(#function)
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    // ui인스턴스를 생성하거나 되돌릴때 호출된다.
    // 이 메소드 안에서 새로운 씬이나 보여주려고하는 씬과 관련된 데이터를 로딩하기 시작하면된다.
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print(#function)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        AppController.shared.show(in: window)
        
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
    }
    
    
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            handleDynamicLinks(url: incomingURL)
        }
    }
    
    
    
    func stateRestorationActivity(for: UIScene) -> NSUserActivity? { return nil }
    // Returns a user activity object encapsulating the current state of the specified scene.
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    private func handleDynamicLinks(url: URL) {
        DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLinks, error in
            guard let url = dynamicLinks?.url, let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
            
            // Check for specific URL components that you need.
            guard let params = components.queryItems else {
                return
            }
            // 이 후행 클로저는 main Queue 에서 실행됨.
            if let studyID = params.first(where: { $0.name == "studyId" })?.value?.toInt() {
                
                let inviteeLandingViewController = InviteeLandingViewController(studyID: studyID)
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                let rootViewController = sceneDelegate.window?.rootViewController
                inviteeLandingViewController.modalPresentationStyle = .fullScreen
                rootViewController?.present(inviteeLandingViewController, animated: true)
            } else {
                print("params not exist")
            }
        }
    }
}

