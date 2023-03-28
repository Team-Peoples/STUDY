//
//  AppDelegate.swift
//  STUDYA
//
//  Created by 서동운 on 2022/08/01.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin
import FirebaseCore
import FirebaseDynamicLinks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 다이나믹링크
        FirebaseApp.configure()
        
        // 카카오 로그인
        KakaoSDK.initSDK(appKey: "ed23abff026b1ec548a706e81bd6ea22")
        
        // 네이버 로그인
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.setOnlyPortraitSupportInIphone(true)  //세로 화면에서만 인증
        instance?.serviceUrlScheme = kServiceAppUrlScheme // 앱을 등록할 때 입력한 URL Scheme
        instance?.consumerKey = kConsumerKey // 상수 - client id
        instance?.consumerSecret = kConsumerSecret // pw
        instance?.appName = kServiceAppName // app name
        
        UserDefaults.standard.set(false, forKey: Constant.isSwitchOn)
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
        return application(app,
                           open: url,
                           sourceApplication: options[UIApplication.OpenURLOptionsKey
                            .sourceApplication] as? String,
                           annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
          print(dynamicLink.url)
        return true
      }
      return true
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        // Get URL components from the incoming user activity.
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return false
        }

        // Check for specific URL components that you need.
//        guard let path = components.path,
//        let params = components.queryItems else {
//            return false
//        }
//        print("path = \(path)")
//
//        if let albumName = params.first(where: { $0.name == "albumname" } )?.value,
//            let photoIndex = params.first(where: { $0.name == "index" })?.value {
//
//            print("album = \(albumName)")
//            print("photoIndex = \(photoIndex)")
//            return true
//
//        } else {
//            print("Either album name or photo index missing")
//            return false
//        }
        return true
    }
    // domb: 링크가 있으면 이렇게 처리??
//        if let appURL = URL(string: "https://myphotoapp.example.com/albums?albumname=vacation&index=1") {
//            UIApplication.shared.open(appURL) { success in
//                if success {
//                    print("The URL was delivered successfully.")
//                } else {
//                    print("The URL failed to open.")
//                }
//            }
//        } else {
//            print("Invalid URL specified.")
//        }
      
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

