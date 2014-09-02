//
//  AppDelegate.swift
//  socketio
//
//  Created by Derek J. Kinsman on 2014-08-11.
//  Copyright (c) 2014 Teehan + Lax. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {

        let VC:ViewController = ViewController()
        self.window!.rootViewController = VC
        self.window!.backgroundColor = UIColor.whiteColor()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {}
    func applicationDidEnterBackground(application: UIApplication!) {}
    func applicationWillEnterForeground(application: UIApplication!) {}
    func applicationDidBecomeActive(application: UIApplication!) {}
    func applicationWillTerminate(application: UIApplication!) {}

}

