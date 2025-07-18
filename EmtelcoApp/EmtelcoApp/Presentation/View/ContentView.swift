//
//  ContentView.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Prueba de Notificaciones + Red")
            
            Button("Probar notificación") {
                NotificationManager.shared.sendNotification(
                    title: "Prueba",
                    body: "Esto es una notificación local"
                )
            }
        }
        .padding()
    }
}
