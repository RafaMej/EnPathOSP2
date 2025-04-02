//
//  HomeView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI

struct HomeView: View {
    @State private var date = Date()
    @State private var greetingOpacity = 0.0
    @State private var cardOpacity = 0.0
    @State private var reminderOffset: CGFloat = 100
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: date)
        if hour < 12 {
            return "Buenos días"
        } else if hour < 19 {
            return "Buenas tardes"
        } else {
            return "Buenas noches"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Saludo
                HStack {
                    VStack(alignment: .leading) {
                        Text(greeting)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if let user = AppState.shared.currentUser {
                            Text(user.name)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                .opacity(greetingOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.6)) {
                        greetingOpacity = 1.0
                    }
                }
                
                // Resumen del día
                DailySummaryCard()
                    .padding(.horizontal)
                    .opacity(cardOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.6).delay(0.2)) {
                            cardOpacity = 1.0
                        }
                    }
                
                // Próximos recordatorios
                Text("Próximos recordatorios")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                
                ForEach(AppState.shared.medicationReminders) { reminder in
                    ReminderCard(reminder: reminder)
                        .padding(.horizontal)
                        .offset(y: reminderOffset)
                        .onAppear {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
                                reminderOffset = 0
                            }
                        }
                }
                
                Spacer()
            }
            .padding(.top)
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97).edgesIgnoringSafeArea(.all))
    }
}

struct DailySummaryCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Resumen del día")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
            
            HStack(spacing: 20) {
                StatusItem(icon: "pill.fill", value: "2", label: "Medicinas")
                StatusItem(icon: "calendar", value: "1", label: "Citas")
                StatusItem(icon: "figure.walk", value: "15", label: "Ejercicio")
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
        .scaleEffect(isAnimating ? 1.0 : 0.95)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

struct StatusItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

struct ReminderCard: View {
    let reminder: Reminder
    @State private var isCompleted = false
    
    var body: some View {
        HStack {
            Image(systemName: "bell.fill")
                .font(.title2)
                .foregroundColor(.orange)
                .padding(.trailing, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(reminder.title)
                    .font(.headline)
                
                Text(reminder.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(reminder.time, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    isCompleted.toggle()
                }
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompleted ? .green : .gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
