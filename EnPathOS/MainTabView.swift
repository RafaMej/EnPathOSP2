//
//  MainTabView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var showVoiceAssistant = false
    
    var body: some View {
        ZStack {
            TabView(selection: $appState.selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Inicio", systemImage: "house.fill")
                    }
                    .tag(0)
                
                WellnessView()
                    .tabItem {
                        Label("Bienestar", systemImage: "heart.fill")
                    }
                    .tag(1)
                
                CognitiveView()
                    .tabItem {
                        Label("Mente", systemImage: "brain.head.profile")
                    }
                    .tag(2)
                
                HealthView()
                    .tabItem {
                        Label("Salud", systemImage: "cross.fill")
                    }
                    .tag(3)
                
                ProfileView()
                    .tabItem {
                        Label("Perfil", systemImage: "person.fill")
                    }
                    .tag(4)
            }
            .accentColor(.blue)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            showVoiceAssistant.toggle()
                        }
                    }) {
                        Image(systemName: "waveform.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 100)
                }
            }
            
            // Botón de emergencia
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            appState.activateEmergency()
                        }
                    }) {
                        Text("Me siento mal")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(20)
                            .shadow(color: Color.red.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }
                
                Spacer()
            }
            
            if showVoiceAssistant {
                VoiceAssistantView(isPresented: $showVoiceAssistant)
                    .transition(.move(edge: .bottom))
            }
            
            if appState.showEmergencyAlert {
                EmergencyAlertView()
                    .transition(.scale)
            }
        }
        .animation(.default, value: showVoiceAssistant)
        .animation(.default, value: appState.showEmergencyAlert)
    }
}
