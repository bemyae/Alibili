//
//  AppDelegate.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/07.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        RootViewNavigator().updateRootViewController()
        
//        let audioSession = AVAudioSession.sharedInstance()
//
//        do {
//            try audioSession.setCategory(.playback, mode: .default, policy: .default)
////            try audioSession.overrideOutputAudioPort(AVAudioSession.Port.airPlay)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//
//            for outputPort in audioSession.currentRoute.outputs {
////                if outputPort.portType == AVAudioSession.Port.airPlay {
////                        return true
////                    }
//                print(outputPort.portName)
//                print(outputPort.portType)
//            }
//
//        } catch {
//            print("fail to set audio session route sharing policy: \(error)")
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, policy: .longFormAudio)
//            try session.overrideOutputAudioPort(.none)
            try session.setActive(true)
            print("outputs: \(session.currentRoute.outputs)")
//                session.setOutputDataSource(AVAudioSessionDataSourceDescription?)
        } catch {
              print("error: \(error)")
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

