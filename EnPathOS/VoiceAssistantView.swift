//
//  VoiceAssistantView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI

struct VoiceAssistantView: View {
    @EnvironmentObject var appState: AppState
    @Binding var isPresented: Bool
    @State private var message = ""
    @State private var isListening = false
    @State private var messages: [AssistantMessage] = []
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Asistente de voz")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            
            // Messages
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack(spacing: 15) {
                        if messages.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "waveform.circle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                                
                                Text("¿En qué puedo ayudarte hoy?")
                                    .font(.headline)
                                
                                Text("Puedes preguntarme sobre tus medicamentos, citas médicas, ejercicios, o pedirme que te lea alguna información.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .padding(.vertical, 40)
                        } else {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                            .onChange(of: messages, { oldValue, newValue in
                                if let lastMessage = messages.last {
                                    withAnimation {
                                        scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            })
                            
                        }
                    }
                    .padding()
                }
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            
            // Input area
            VStack(spacing: 10) {
                if isProcessing {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
                
                HStack {
                    TextField("Escribe un mensaje...", text: $message)
                        .padding(10)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(20)
                    
                    Button(action: {
                        sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding(10)
                    }
                    .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    Button(action: {
                        toggleVoiceRecording()
                    }) {
                        Image(systemName: isListening ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.title2)
                            .foregroundColor(isListening ? .red : .blue)
                            .padding(5)
                    }
                }
            }
            .padding()
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        .frame(height: UIScreen.main.bounds.height * 0.7)
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func sendMessage() {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = AssistantMessage(content: message, isUser: true)
        messages.append(userMessage)
        
        // Clear input field
        let userQuery = message
        message = ""
        
        // Show processing state
        isProcessing = true
        
        // Simulate processing time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Generate response based on query
            let response = generateResponse(to: userQuery)
            let assistantMessage = AssistantMessage(content: response, isUser: false)
            messages.append(assistantMessage)
            isProcessing = false
        }
    }
    
    private func toggleVoiceRecording() {
        isListening.toggle()
        
        if isListening {
            // Start recording - in a real app, you'd implement speech recognition
            // For this demo, we'll simulate voice recognition after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if isListening {
                    isListening = false
                    message = "¿Cuándo es mi próxima cita médica?"
                }
            }
        } else {
            // Stop recording
        }
    }
    
    private func generateResponse(to query: String) -> String {
        // In a real app, this would connect to an AI service or database
        // For this demo, we'll use simple keyword matching
        let lowercasedQuery = query.lowercased()
        
        if lowercasedQuery.contains("medicamento") || lowercasedQuery.contains("medicina") {
            return "Tienes un recordatorio para tomar Enalapril a las 8:00 AM y Aspirina a las 8:00 PM todos los días."
        } else if lowercasedQuery.contains("cita") {
            return "Tu próxima cita médica es con el Dr. Martínez el 15 de abril a las 10:00 AM en la Clínica San Rafael."
        } else if lowercasedQuery.contains("ejercicio") || lowercasedQuery.contains("actividad") {
            return "Según tu plan de bienestar, hoy deberías realizar 30 minutos de caminata y ejercicios de estiramiento. ¿Te gustaría que te muestre los ejercicios recomendados?"
        } else if lowercasedQuery.contains("sentir") && lowercasedQuery.contains("mal") {
            return "Lamento que no te sientas bien. ¿Puedes decirme qué síntomas tienes? Puedo ayudarte a contactar a tu médico o a un servicio de emergencia si es necesario."
        } else {
            return "Estoy aquí para ayudarte con información sobre tus medicamentos, citas médicas, ejercicios recomendados y más. ¿Puedes ser más específico con tu pregunta?"
        }
    }
}

struct MessageBubble: View {
    let message: AssistantMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(message.isUser ? Color.blue : Color.white)
                .foregroundColor(message.isUser ? .white : .black)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

struct AssistantMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
}
