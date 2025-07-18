//
//  NetworkMonitor.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import Network
import UserNotifications

import Network

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    @Published var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let wasConnected = self?.isConnected ?? true
                self?.isConnected = (path.status == .satisfied)
                
                print("🔄 Estado de red: \(path.status == .satisfied ? "Conectado" : "Desconectado")")
                
                if wasConnected != (path.status == .satisfied) {
                    if path.status == .satisfied {
                        NotificationManager.shared.sendNotification(
                            title: "Conexión restablecida",
                            body: "Tu dispositivo volvió a estar online."
                        )
                    } else {
                        NotificationManager.shared.sendNotification(
                            title: "Sin conexión",
                            body: "Has perdido la conexión a Internet."
                        )
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }
}
