//
//  AppDelegate.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/21/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        APIManager.shared.search(query: "") { result in
//            switch result {
//            case .success(let response):
//                print(response.result)
//            case .failure(let error):
//                print(error)
//            }
//        }
        debug()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  
    }


    private func debug()
    {
//        APIManager.shared.marketData(for: "AAPL") { result in
//
//            switch result{
//            case .success(let data):
//                let candleStick = data.candleStricks
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}

