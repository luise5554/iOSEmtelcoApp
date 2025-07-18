//
//  EmtelcoAppApp.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import SwiftUI
import UserNotifications

@main
struct EmtelcoAppApp: App {
    
    init() {
        // ✅ Pedir permiso para notificaciones
        NotificationManager.shared.requestPermission()
        // ✅ Iniciar monitoreo de red
        _ = NetworkMonitor.shared
    }

    var body: some Scene {
        WindowGroup {
            PokemonListView()
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Permiso para notificaciones locales concedido")
            } else {
                print("❌ Permiso denegado")
            }
        }
    }
}
