//
//  AppState.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI
import SwiftData
import AVKit
import CoreLocation
import UserNotifications

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    @Published var selectedTab = 0
    @Published var showEmergencyAlert = false
    @Published var medicalHistory: [MedicalRecord] = []
    @Published var medicationReminders: [Reminder] = []
    @Published var appointments: [Appointment] = []
    @Published var wellnessLog: [WellnessEntry] = []
    @Published var isVoiceAssistantActive = false
    
    // Add userProfile property to match ProfileView requirements
    @Published var userProfile: UserProfile = UserProfile(
        name: "Usuario",
        email: "usuario@ejemplo.com",
        birthDate: Date(),
        bloodType: "Desconocido",
        allergies: "",
        emergencyContact: ""
    )
    
    // Cargar datos del usuario
    func loadUserData() {
        // Simulación de carga de datos
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = User(
                id: "1",
                name: "Carlos Ramírez",
                age: 72,
                role: .senior,
                emergencyContacts: [
                    Contact(id: "1", name: "María Ramírez", phone: "+34600123456", relation: "Hija"),
                    Contact(id: "2", name: "Dr. Hernández", phone: "+34600789012", relation: "Médico")
                ]
            )
            
            self.medicalHistory = [
                MedicalRecord(id: "1", date: Date(), title: "Revisión anual", details: "Resultados normales", diagnosis: "Buen estado, con dolor de garganta", medications: "Ibuprofeno", notes: "Salir a caminar", hasAttachment: true),
                MedicalRecord(id: "2", date: Date().addingTimeInterval(-7_776_000), title: "Análisis de sangre", details: "Resultados normales", diagnosis: "Dolor de estomago y cansancio", medications: "Berocca y Paracetamol", notes: "Hacer ejercio areobico y de fuerza diario", hasAttachment: true),
            ]
            
            self.medicationReminders = [
                Reminder(id: "1", title: "Enalapril", description: "1 pastilla", time: Date().addingTimeInterval(3600), isDaily: true),
                Reminder(id: "2", title: "Simvastatina", description: "1 pastilla", time: Date().addingTimeInterval(64800), isDaily: true)
            ]
            
            // Update userProfile with current user data
            if let user = self.currentUser {
                self.userProfile.name = user.name
                
                // Set emergency contact if available
                if let primaryContact = user.emergencyContacts.first {
                    self.userProfile.emergencyContact = "\(primaryContact.name) - \(primaryContact.phone)"
                }
            }
            
            self.isLoggedIn = true
        }
    }
    
    // Add update profile method to match EditProfileView
    func updateProfile(
        name: String,
        email: String,
        birthDate: Date,
        bloodType: String,
        allergies: String,
        emergencyContact: String
    ) {
        self.userProfile.name = name
        self.userProfile.email = email
        self.userProfile.birthDate = birthDate
        self.userProfile.bloodType = bloodType
        self.userProfile.allergies = allergies
        self.userProfile.emergencyContact = emergencyContact
        
        // Also update the currentUser if needed
        if var user = self.currentUser {
            user.name = name
            self.currentUser = user
        }
    }
    
    // Add logout method
    func logout() {
        self.isLoggedIn = false
        self.currentUser = nil
        // Additional cleanup as needed
    }
    
    func activateEmergency() {
        showEmergencyAlert = true
        // Activar llamada a contacto de emergencia
        if let primaryContact = currentUser?.emergencyContacts.first {
            print("Llamando a contacto de emergencia: \(primaryContact.name)")
            // Implementar llamada real
        }
        // Activar geolocalización
        LocationManager.shared.startUpdatingLocation()
    }
}

// Add UserProfile struct to match what's used in ProfileView
struct UserProfile {
    var name: String
    var email: String
    var birthDate: Date
    var bloodType: String
    var allergies: String
    var emergencyContact: String
}
