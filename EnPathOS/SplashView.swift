//
//  SplashView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI

struct SplashView: View {
    @State private var logoScale = 0.8
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.4, blue: 0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .scaleEffect(logoScale)
                
                Text("EnPathOS")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Bienestar para todas las edades")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    logoScale = 1.0
                }
                withAnimation(.easeIn(duration: 1.0)) {
                    opacity = 1.0
                }
            }
        }
    }
}
