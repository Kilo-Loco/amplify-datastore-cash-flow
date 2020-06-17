//
//  AppDelegate.swift
//  Cash-Flow
//
//  Created by Kyle Lee on 6/17/20.
//  Copyright © 2020 Kilo Loco. All rights reserved.
//

import Amplify
import AmplifyPlugins
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            try Amplify.add(
                plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels())
            )
            try Amplify.configure()
            
            print("Amplify initialized successfully")
            
        } catch {
            print("Could not initialize Amplify \(error)")
        }
        
        return true
    }

}

