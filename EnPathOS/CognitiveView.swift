//
//  CognitiveView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI

struct CognitiveView: View {
    let games: [CognitiveGame] = [
        CognitiveGame(id: "1", name: "Memoria Visual", description: "Ejercita tu memoria con imágenes", difficulty: 1, type: .memory),
        CognitiveGame(id: "2", name: "Puzzle Diario", description: "Resuelve problemas lógicos", difficulty: 2, type: .logic),
        CognitiveGame(id: "3", name: "Palabras", description: "Encuentra palabras ocultas", difficulty: 2, type: .language)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Encabezado
                Text("Estimulación Cognitiva")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("Ejercita tu mente jugando a estos juegos diarios")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Juego destacado
                FeaturedGameCard()
                    .padding(.horizontal)
                
                // Lista de juegos
                Text("Juegos diarios")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                ForEach(games) { game in
                    GameCard(game: game)
                        .padding(.horizontal)
                }
                
                // Progreso
                Text("Tu progreso")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                CognitiveProgressView()
                    .padding(.horizontal)
                
                Spacer(minLength: 80)
            }
            .padding(.top)
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97).edgesIgnoringSafeArea(.all))
    }
}

struct FeaturedGameCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Juego destacado")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Secuencia de colores")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Recuerda la secuencia de colores y repítela en orden")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                HStack {
                    ForEach(0..<4) { i in
                        Circle()
                            .fill(colorForIndex(i))
                            .frame(width: 30, height: 30)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 0.5)
                                    .repeatCount(1)
                                    .delay(Double(i) * 0.5)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                }
                .padding(.vertical)
                
                Button(action: {}) {
                    Text("Jugar ahora")
                        .font(.headline)
                        .foregroundColor(.purple)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(20)
                }
            }
            .padding()
        }
        .frame(height: 220)
        .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
        .onAppear {
            isAnimating = true
        }
    }
    
    func colorForIndex(_ index: Int) -> Color {
        let colors: [Color] = [.red, .blue, .green, .yellow]
        return colors[index % colors.count]
    }
}

struct GameCard: View {
    let game: CognitiveGame
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(colorForType(game.type))
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconForType(game.type))
                    .foregroundColor(.white)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(game.name)
                    .font(.headline)
                
                Text(game.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    ForEach(0..<5) { i in
                        Image(systemName: i < game.difficulty ? "star.fill" : "star")
                            .foregroundColor(i < game.difficulty ? .yellow : .gray)
                            .font(.caption)
                    }
                    .padding(.top, 2)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(colorForType(game.type))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    func colorForType(_ type: GameType) -> Color {
        switch type {
        case .memory: return .purple
        case .logic: return .blue
        case .language: return .green
        }
    }
    
    func iconForType(_ type: GameType) -> String {
        switch type {
        case .memory: return "brain.head.profile"
        case .logic: return "puzzlepiece.fill"
        case .language: return "textformat.abc"
        }
    }
}

struct CognitiveProgressView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Esta semana")
                .font(.headline)
            
            HStack {
                VStack {
                    Text("7")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    
                    Text("Juegos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 30)
                
                VStack {
                    Text("85%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Aciertos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 30)
                
                VStack {
                    Text("3")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Racha")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            
            Divider()
                .padding(.vertical, 5)
            
            Text("Juegos completados hoy: 1/3")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProgressView(value: 0.33)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding(.top, 2)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
