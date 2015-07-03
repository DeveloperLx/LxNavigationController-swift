//
//  AppDelegate.swift
//  LxNavigationControllerDemo
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        let vc = ViewController()
        let nc = LxNavigationController(rootViewController: vc)
        window?.rootViewController = nc
        
        return true
    }
}

