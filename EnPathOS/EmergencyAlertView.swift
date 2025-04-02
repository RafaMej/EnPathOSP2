//
//  EmergencyAlertView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//

import SwiftUI

struct EmergencyAlertView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedEmergency: EmergencyType = .discomfort
    @State private var additionalInfo = ""
    @State private var isCallingSOS = false
    @State private var showConfirmation = false
    
    enum EmergencyType: String, CaseIterable, Identifiable {
        case discomfort = "Malestar general"
        case chestPain = "Dolor en el pecho"
        case breathingDifficulty = "Dificultad para respirar"
        case dizziness = "Mareo o desmayo"
        case confusion = "Confusión"
        case other = "Otro"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    if !isCallingSOS && !showConfirmation {
                        withAnimation {
                            appState.showEmergencyAlert = false
                        }
                    }
                }
            
            VStack(spacing: 15) {
                if isCallingSOS {
                    sosCallingView
                } else if showConfirmation {
                    confirmationView
                } else {
                    emergencySelectionView
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(.horizontal, 20)
        }
    }
    
    var emergencySelectionView: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.title)
                
                Text("Alerta de emergencia")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        appState.showEmergencyAlert = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            
            Divider()
            
            Text("¿Qué estás sintiendo?")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Picker("Tipo de emergencia", selection: $selectedEmergency) {
                ForEach(EmergencyType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            
            TextField("Información adicional", text: $additionalInfo)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            
            HStack(spacing: 15) {
                Button(action: {
                    withAnimation {
                        appState.showEmergencyAlert = false
                    }
                }) {
                    Text("Cancelar")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation {
                        showConfirmation = true
                    }
                }) {
                    Text("Siguiente")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    var confirmationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "phone.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("¿Quieres llamar a emergencias?")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("Se enviará tu ubicación y datos médicos a los servicios de emergencia.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Síntomas: \(selectedEmergency.rawValue)")
                if !additionalInfo.isEmpty {
                    Text("Detalles: \(additionalInfo)")
                }
                Text("Ubicación: Se compartirá automáticamente")
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .font(.subheadline)
            
            HStack(spacing: 15) {
                Button(action: {
                    withAnimation {
                        showConfirmation = false
                    }
                }) {
                    Text("Atrás")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation {
                        isCallingSOS = true
                        // In a real app, this would trigger actual emergency services
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                appState.showEmergencyAlert = false
                            }
                        }
                    }
                }) {
                    Text("Llamar")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    var sosCallingView: some View {
        VStack(spacing: 20) {
            Text("Llamando a emergencias...")
                .font(.headline)
                .fontWeight(.bold)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                .scaleEffect(1.5)
                .padding()
            
            Text("Enviando ubicación y datos médicos")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("No cierres la aplicación")
                .font(.caption)
                .foregroundColor(.red)
                .padding(.top)
        }
        .padding()
    }
}
