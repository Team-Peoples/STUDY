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

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        AppController.shared.show(in: window)
        
        // Get URL components from the incoming user activity.
        guard let userActivity = connectionOptions.userActivities.first,
              userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL else {
            return
        }
        
        // domb: DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: URL)과 다른점.
        let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLinks, error in
            guard let url = dynamicLinks?.url, let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
            
//            // Check for specific URL components that you need.
//            guard let path = components.path,
//                let params = components.queryItems else {
//                return
//            }
//            print("path = \(path)")
//
//            if let albumName = params.first(where: { $0.name == "albumname" })?.value,
//                let photoIndex = params.first(where: { $0.name == "index" })?.value {
//                
//                print("album = \(albumName)")
//                print("photoIndex = \(photoIndex)")
//            } else {
//                print("Either album name or photo index missing")
//            }
        }
    }
    
    
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
//        if let incomingURL = userActivity.webpageURL {
//            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLinks, error in
//
//                // Dynamic Link 처리
//                print(dynamicLinks?.url)
//            }
//        }
    }
    
    
    
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

