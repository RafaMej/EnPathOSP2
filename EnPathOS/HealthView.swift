//
//  HealthView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI

struct HealthView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAddReminder = false
    @State private var showAddAppointment = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Encabezado
                Text("Salud")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Recordatorios de medicamentos
                HStack {
                    Text("Medicamentos")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showAddReminder = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                ForEach(appState.medicationReminders) { reminder in
                    MedicationReminderCard(reminder: reminder)
                        .padding(.horizontal)
                }
                
                // Citas médicas
                HStack {
                    Text("Citas médicas")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showAddAppointment = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                if appState.appointments.isEmpty {
                    Text("No hay citas programadas")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                } else {
                    ForEach(appState.appointments) { appointment in
                        AppointmentCard(appointment: appointment)
                            .padding(.horizontal)
                    }
                }
                
                // Historial médico
                Text("Historial médico")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                ForEach(appState.medicalHistory) { record in
                    AddAppointmentView.MedicalRecordCard(record: record)
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 80)
            }
            .padding(.top)
            .sheet(isPresented: $showAddReminder) {
                AddReminderView()
            }
            .sheet(isPresented: $showAddAppointment) {
                AddAppointmentView()
            }
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97).edgesIgnoringSafeArea(.all))
    }
}

struct MedicationReminderCard: View {
    let reminder: Reminder
    @State private var isCompleted: Bool
    
    init(reminder: Reminder) {
        self.reminder = reminder
        _isCompleted = State(initialValue: reminder.isCompleted)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(reminder.title)
                    .font(.headline)
                    .strikethrough(isCompleted)
                    .foregroundColor(isCompleted ? .secondary : .primary)
                
                Text(reminder.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                        .font(.caption)
                    
                    Text(reminder.time, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if reminder.isDaily {
                        Image(systemName: "repeat")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Text("Diario")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
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

struct AddReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var description = ""
    @State private var time = Date()
    @State private var isDaily = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles del medicamento")) {
                    TextField("Nombre del medicamento", text: $title)
                    TextField("Descripción (ej. 1 pastilla)", text: $description)
                }
                
                Section(header: Text("Horario")) {
                    DatePicker("Hora", selection: $time, displayedComponents: .hourAndMinute)
                    Toggle("Repetir diariamente", isOn: $isDaily)
                }
            }
            .navigationTitle("Nuevo medicamento")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Guardar") {
                    saveReminder()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    func saveReminder() {
        print("Guardando medicamento: \(title)")
        // Aquí implementar la lógica para guardar el recordatorio
    }
}

struct AppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(appointment.title)
                    .font(.headline)
                
                Spacer()
                
                Text(appointment.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(appointment.doctor)
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.red)
                    .font(.caption)
                
                Text(appointment.location)
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.green)
                    .font(.caption)
                
                Text(appointment.date, style: .time)
                    .font(.subheadline)
            }
            
            if !appointment.notes.isEmpty {
                Text(appointment.notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct AddAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var doctor = ""
    @State private var location = ""
    @State private var date = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles de la cita")) {
                    TextField("Título", text: $title)
                    TextField("Doctor", text: $doctor)
                    TextField("Ubicación", text: $location)
                }
                
                Section(header: Text("Fecha y hora")) {
                    DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Notas adicionales")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Nueva cita médica")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Guardar") {
                    saveAppointment()
                    presentationMode.wrappedValue.dismiss()
                }
                    .disabled(title.isEmpty || doctor.isEmpty)
            )
        }
    }
    
    func saveAppointment() {
        print("Guardando cita: \(title)")
    }
    
struct MedicalRecordCard: View {
        let record: MedicalRecord
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(record.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(record.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if !record.diagnosis.isEmpty {
                    HStack {
                        Image(systemName: "stethoscope")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Text(record.diagnosis)
                            .font(.subheadline)
                    }
                }
                
                if !record.medications.isEmpty {
                    HStack(alignment: .top) {
                        Image(systemName: "pill.fill")
                            .foregroundColor(.purple)
                            .font(.caption)
                        
                        Text(record.medications)
                            .font(.subheadline)
                    }
                }
                
                if !record.notes.isEmpty {
                    Text(record.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                }
                
                if record.hasAttachment {
                    HStack {
                        Image(systemName: "paperclip")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text("Ver adjunto")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 5)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
