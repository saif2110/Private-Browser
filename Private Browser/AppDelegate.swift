//
//  AppDelegate.swift
//  Private Browser
//
//  Created by Saif Mukadam on 29/01/24.
//

import UIKit
import RevenueCat


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_AkDFltEviXnLgkwrxYsSyozcfoU")
        
        isPurchasesed()
        Manager.isnumberofTimesAppOpenKey = Manager.isnumberofTimesAppOpenKey + 1
        
        return true
    }

    func isPurchasesed() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if !(customerInfo?.entitlements.active.isEmpty ?? false) {
                Manager.isPro = true
            }else{
                Manager.isPro = false
            }
        }
    }
    
}

