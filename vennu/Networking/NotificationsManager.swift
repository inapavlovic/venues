//
//  NotificationsManager.swift
//  vennu
//
//  Created by Ina Statkic on 16/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import FirebaseMessaging
import UserNotifications

final class NotificationsManager: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
        let authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions, completionHandler: { _,_ in
            
        })
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = Messaging.messaging().fcmToken {
            FirebaseManager.Endpoint.users.child(FirebaseManager.shared.uid).updateChildValues(["FCMToken" : token])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
     }
    
}
