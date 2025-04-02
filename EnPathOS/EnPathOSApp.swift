//
//  EnPathOSApp.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//

import SwiftUI
import SwiftData
import AVKit
import CoreLocation
import UserNotifications

@main
struct EnPathOSApp: App {
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.light)
                .onAppear {
                    requestPermissions()
                }
        }
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        LocationManager.shared.requestAuthorization()
    }
}
