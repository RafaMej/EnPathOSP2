//
//  OnboardingView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI

struct OnboardingView: View {
    @State private var selectedPage = 0
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.95, blue: 0.97)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TabView(selection: $selectedPage) {
                    OnboardingPageView(
                        image: "figure.walk",
                        title: "Bienestar Físico",
                        description: "Rutinas de ejercicio adaptadas a distintos niveles de movilidad."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        image: "brain",
                        title: "Estimulación Cognitiva",
                        description: "Juegos de memoria y razonamiento lógico para mantener la mente activa."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        image: "pill",
                        title: "Gestión de Salud",
                        description: "Recordatorios para medicamentos y citas médicas."
                    )
                    .tag(2)
                    
                    OnboardingPageView(
                        image: "waveform",
                        title: "Asistente Inteligente",
                        description: "Sistema de acompañamiento activado por voz o botón."
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Button(action: {
                    withAnimation {
                        if selectedPage < 3 {
                            selectedPage += 1
                        } else {
                            AppState.shared.loadUserData()
                        }
                    }
                }) {
                    Text(selectedPage < 3 ? "Siguiente" : "Comenzar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let image: String
    let title: String
    let description: String
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
                .scaleEffect(isAnimating ? 1.0 : 0.7)
            
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : 20)
        }
        .padding()
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}
