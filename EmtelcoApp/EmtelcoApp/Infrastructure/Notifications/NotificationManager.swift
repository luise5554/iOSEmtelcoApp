//
//  NotificationManager.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self  // ✅ Para que muestre en foreground
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print(granted ? "✅ Permiso concedido" : "❌ Permiso denegado")
        }
    }
    
    // ✅ Mostrar aunque la app esté abierta
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
