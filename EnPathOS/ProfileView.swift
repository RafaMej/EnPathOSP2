//
//  ProfileView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showEditProfile = false
    @State private var showSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Perfil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Profile image and name
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    
                    Text(appState.userProfile.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    
                    Text(appState.userProfile.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showEditProfile = true
                    }) {
                        Text("Editar perfil")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    .padding(.top, 5)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Medical information
                VStack(alignment: .leading, spacing: 15) {
                    Text("Información médica")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    HStack {
                        Text("Fecha de nacimiento:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(appState.userProfile.birthDate, style: .date)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Tipo de sangre:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(appState.userProfile.bloodType)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Alergias:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(appState.userProfile.allergies.isEmpty ? "Ninguna" : appState.userProfile.allergies)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Contacto de emergencia:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(appState.userProfile.emergencyContact)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Settings
                Button(action: {
                    showSettings = true
                }) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                        
                        Text("Configuración")
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                // Help & Support
                Button(action: {
                    // Action for help
                }) {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.blue)
                        
                        Text("Ayuda y soporte")
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                // Logout button
                Button(action: {
                    // Logout action
                    appState.logout()
                }) {
                    Text("Cerrar sesión")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 80)
            }
            .padding(.top)
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97).edgesIgnoringSafeArea(.all))
    }
}

struct EditProfileView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var email: String
    @State private var birthDate: Date
    @State private var bloodType: String
    @State private var allergies: String
    @State private var emergencyContact: String
    
    init() {
        let profile = AppState.shared.userProfile
        _name = State(initialValue: profile.name)
        _email = State(initialValue: profile.email)
        _birthDate = State(initialValue: profile.birthDate)
        _bloodType = State(initialValue: profile.bloodType)
        _allergies = State(initialValue: profile.allergies)
        _emergencyContact = State(initialValue: profile.emergencyContact)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información personal")) {
                    TextField("Nombre completo", text: $name)
                    TextField("Correo electrónico", text: $email)
                        .keyboardType(.emailAddress)
                    DatePicker("Fecha de nacimiento", selection: $birthDate, displayedComponents: .date)
                }
                
                Section(header: Text("Información médica")) {
                    Picker("Tipo de sangre", selection: $bloodType) {
                        Text("A+").tag("A+")
                        Text("A-").tag("A-")
                        Text("B+").tag("B+")
                        Text("B-").tag("B-")
                        Text("AB+").tag("AB+")
                        Text("AB-").tag("AB-")
                        Text("O+").tag("O+")
                        Text("O-").tag("O-")
                        Text("Desconocido").tag("Desconocido")
                    }
                    
                    TextField("Alergias", text: $allergies)
                }
                
                Section(header: Text("Contacto de emergencia")) {
                    TextField("Nombre y teléfono", text: $emergencyContact)
                }
            }
            .navigationTitle("Editar perfil")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Guardar") {
                    saveProfile()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    func saveProfile() {
        // Save profile information
        appState.updateProfile(
            name: name,
            email: email,
            birthDate: birthDate,
            bloodType: bloodType,
            allergies: allergies,
            emergencyContact: emergencyContact
        )
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("fontSize") private var fontSize = 1 // 0: small, 1: medium, 2: large
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferencias")) {
                    Toggle("Notificaciones", isOn: $notificationsEnabled)
                    Toggle("Modo oscuro", isOn: $darkModeEnabled)
                }
                
                Section(header: Text("Tamaño de texto")) {
                    Picker("Tamaño de texto", selection: $fontSize) {
                        Text("Pequeño").tag(0)
                        Text("Mediano").tag(1)
                        Text("Grande").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Aplicación")) {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Términos y condiciones") {
                        // Action for terms
                    }
                    
                    Button("Política de privacidad") {
                        // Action for privacy policy
                    }
                }
            }
            .navigationTitle("Configuración")
            .navigationBarItems(trailing: Button("Listo") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
