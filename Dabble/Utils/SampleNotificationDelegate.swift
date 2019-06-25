//
//  SampleNotificationDelegate.swift
//  Dabble
//
//  Created by Vivek Rai on 25/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//


import Foundation
import UserNotifications
import UserNotificationsUI
import SafariServices

class SampleNotificationDelegate: UIViewController, UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound, .badge])
    }
    
    
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action******************************")
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let url = URL(string: (response.notification.request.content.userInfo["url"] as? String)!) {
                let safari = SFSafariViewController(url: url)
                appDelegate?.window?.rootViewController?.present(safari, animated: true, completion: nil)
            }
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
}
