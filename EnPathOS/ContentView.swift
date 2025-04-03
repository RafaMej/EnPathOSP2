//
//  ContentView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showSplash = true
    @ObservedObject private var appState = AppState.shared
    
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeOut(duration: 0.8)) {
                                showSplash = false
                            }
                        }
                    }
            } else if AppState.shared.isLoggedIn {
                MainTabView()
                    .transition(.opacity)
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showSplash)
        .animation(.easeInOut, value: AppState.shared.isLoggedIn)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState.shared)
    }
}
