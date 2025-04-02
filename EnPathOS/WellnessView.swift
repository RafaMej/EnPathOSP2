//
//  WellnessView.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//// Archivo: WellnessView.swift
import SwiftUI

struct WellnessView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Encabezado
            Text("Bienestar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            // Segmentado
            Picker("", selection: $selectedTab) {
                Text("Ejercicio").tag(0)
                Text("Ánimo").tag(1)
                Text("Alimentación").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Contenido según la pestaña seleccionada
            TabView(selection: $selectedTab) {
                ExerciseView()
                    .tag(0)
                
                MoodView()
                    .tag(1)
                
                NutritionView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97).edgesIgnoringSafeArea(.all))
        .animation(.default, value: selectedTab)
    }
}

struct ExerciseView: View {
    let exercises = [
        ExerciseItem(
            title: "Ejercicios de movilidad suaves",
            description: "Ejercicios sentados para mejorar la flexibilidad",
            duration: "15 minutos",
            difficulty: "Fácil",
            image: "figure.walk"
        ),
        ExerciseItem(
            title: "Caminata en casa",
            description: "Rutina de pasos en interiores",
            duration: "20 minutos",
            difficulty: "Moderado",
            image: "figure.walk"
        ),
        ExerciseItem(
            title: "Yoga para la espalda",
            description: "Estiramientos suaves para el dolor de espalda",
            duration: "10 minutos",
            difficulty: "Fácil",
            image: "figure.mind.and.body"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Tutorial animado
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.7), Color.blue.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tutorial de ejercicios")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Aprende rutinas sencillas adaptadas para tu nivel")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Button(action: {}) {
                                Text("Ver ahora")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(20)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .frame(height: 150)
                .padding(.horizontal)
                
                // Lista de ejercicios
                Text("Ejercicios recomendados")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                ForEach(exercises, id: \.title) { exercise in
                    ExerciseCard(exercise: exercise)
                        .padding(.horizontal)
                }
                
                // Bitácora
                Text("Tu actividad reciente")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                ActivityLogView()
                    .padding(.horizontal)
                
                Spacer(minLength: 80)
            }
            .padding(.top)
        }
    }
}

struct ExerciseItem {
    let title: String
    let description: String
    let duration: String
    let difficulty: String
    let image: String
}

struct ExerciseCard: View {
    let exercise: ExerciseItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: exercise.image)
                    .font(.title)
                    .foregroundColor(.green)
                    .frame(width: 50, height: 50)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(exercise.title)
                        .font(.headline)
                    
                    Text(exercise.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(isExpanded ? nil : 1)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            
            if isExpanded {
                Divider()
                    .padding(.vertical, 5)
                
                HStack {
                    Label(exercise.duration, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label(exercise.difficulty, systemImage: "speedometer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Comenzar")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ActivityLogView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(0..<3) { index in
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    
                    Text(Date().addingTimeInterval(Double(-index) * 86400), style: .date)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(15 + index * 5) min")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
            
            Button(action: {}) {
                Text("Ver historial completo")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct MoodView: View {
    @State private var selectedMood = 3
    @State private var notes = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Selección de estado de ánimo
                Text("¿Cómo te sientes hoy?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                HStack(spacing: 25) {
                    ForEach(1..<6) { index in
                        VStack {
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedMood = index
                                }
                            }) {
                                Image(systemName: moodIcon(for: index))
                                    .font(.system(size: 30))
                                    .foregroundColor(selectedMood == index ? .blue : .gray)
                            }
                            .scaleEffect(selectedMood == index ? 1.2 : 1.0)
                            Text(moodText(for: index))
                                                            .font(.caption)
                                                            .foregroundColor(selectedMood == index ? .blue : .gray)
                                                    }
                                                    .animation(.spring(), value: selectedMood)
                                                }
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(15)
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                            .padding(.horizontal)
                                            
                                            // Notas sobre estado de ánimo
                                            VStack(alignment: .leading, spacing: 10) {
                                                Text("Notas (opcional)")
                                                    .font(.headline)
                                                
                                                TextEditor(text: $notes)
                                                    .frame(height: 100)
                                                    .padding(5)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(10)
                                                
                                                Button(action: {
                                                    saveMoodEntry()
                                                }) {
                                                    Text("Guardar registro")
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity)
                                                        .padding()
                                                        .background(Color.blue)
                                                        .cornerRadius(15)
                                                }
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(15)
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                            .padding(.horizontal)
                                            
                                            // Historial de estados de ánimo
                                            Text("Historial de ánimo")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.horizontal)
                                                .padding(.top)
                                            
                                            MoodHistoryChart()
                                                .padding(.horizontal)
                                            
                                            Spacer(minLength: 80)
                                        }
                                        .padding(.top)
                                    }
                                }
                                
                                func moodIcon(for index: Int) -> String {
                                    switch index {
                                    case 1: return "face.smiling.inverse"
                                    case 2: return "face.smiling"
                                    case 3: return "face.dashed"
                                    case 4: return "face.concerned"
                                    case 5: return "face.scowling"
                                    default: return "face.dashed"
                                    }
                                }
                                
                                func moodText(for index: Int) -> String {
                                    switch index {
                                    case 1: return "Muy bien"
                                    case 2: return "Bien"
                                    case 3: return "Normal"
                                    case 4: return "Mal"
                                    case 5: return "Muy mal"
                                    default: return "Normal"
                                    }
                                }
                                
                                func saveMoodEntry() {
                                    // Aquí se implementaría la lógica para guardar el registro de ánimo
                                    print("Guardando registro de ánimo: \(selectedMood), notas: \(notes)")
                                    notes = ""
                                }
                            }

                            struct MoodHistoryChart: View {
                                let data = [3, 4, 3, 2, 2, 1, 3] // Ejemplo de datos de ánimo para la última semana
                                
                                var body: some View {
                                    VStack(alignment: .leading, spacing: 15) {
                                        HStack {
                                            Text("Últimos 7 días")
                                                .font(.headline)
                                            
                                            Spacer()
                                            
                                            Text("Promedio: 2.5")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        // Gráfico simple
                                        HStack(alignment: .bottom, spacing: 8) {
                                            ForEach(0..<data.count, id: \.self) { index in
                                                VStack {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(moodColor(for: data[index]))
                                                        .frame(height: CGFloat(6 - data[index]) * 15)
                                                    
                                                    Text("\(Calendar.current.shortWeekdaySymbols[(Calendar.current.component(.weekday, from: Date()) + index - 1) % 7])")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                }
                                                .frame(maxWidth: .infinity)
                                            }
                                        }
                                        .padding(.vertical)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                }
                                
                                func moodColor(for value: Int) -> Color {
                                    switch value {
                                    case 1: return .green
                                    case 2: return .blue
                                    case 3: return .yellow
                                    case 4: return .orange
                                    case 5: return .red
                                    default: return .gray
                                    }
                                }
                            }

                            struct NutritionView: View {
                                @State private var showingAddMeal = false
                                
                                var body: some View {
                                    ScrollView {
                                        VStack(spacing: 20) {
                                            // Consejos de nutrición
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [Color.orange.opacity(0.7), Color.red.opacity(0.7)]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                
                                                HStack {
                                                    VStack(alignment: .leading, spacing: 10) {
                                                        Text("Consejos nutricionales")
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                        
                                                        Text("Mantén una alimentación balanceada con proteínas, verduras y frutas")
                                                            .font(.subheadline)
                                                            .foregroundColor(.white.opacity(0.8))
                                                        
                                                        Button(action: {}) {
                                                            Text("Más información")
                                                                .font(.caption)
                                                                .fontWeight(.bold)
                                                                .foregroundColor(.orange)
                                                                .padding(.horizontal, 15)
                                                                .padding(.vertical, 8)
                                                                .background(Color.white)
                                                                .cornerRadius(20)
                                                        }
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "leaf.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 50, height: 50)
                                                        .foregroundColor(.white)
                                                }
                                                .padding()
                                            }
                                            .frame(height: 150)
                                            .padding(.horizontal)
                                            
                                            // Comidas de hoy
                                            HStack {
                                                Text("Comidas de hoy")
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    showingAddMeal = true
                                                }) {
                                                    Image(systemName: "plus.circle.fill")
                                                        .foregroundColor(.blue)
                                                        .font(.title2)
                                                }
                                            }
                                            .padding(.horizontal)
                                            
                                            // Lista de comidas
                                            MealListView()
                                                .padding(.horizontal)
                                            
                                            // Consumo de agua
                                            Text("Consumo de agua")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.horizontal)
                                                .padding(.top)
                                            
                                            WaterIntakeView()
                                                .padding(.horizontal)
                                            
                                            Spacer(minLength: 80)
                                        }
                                        .padding(.top)
                                        .sheet(isPresented: $showingAddMeal) {
                                            AddMealView()
                                        }
                                    }
                                }
                            }

                            struct MealListView: View {
                                let meals = [
                                    Meal(id: "1", name: "Desayuno", time: Date().addingTimeInterval(-4 * 3600), foodItems: ["Pan integral", "Huevo", "Aguacate"]),
                                    Meal(id: "2", name: "Almuerzo", time: Date().addingTimeInterval(-1 * 3600), foodItems: ["Ensalada", "Pollo", "Arroz"])
                                ]
                                
                                var body: some View {
                                    VStack(spacing: 15) {
                                        ForEach(meals) { meal in
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack {
                                                    Text(meal.name)
                                                        .font(.headline)
                                                    
                                                    Spacer()
                                                    
                                                    Text(meal.time, style: .time)
                                                        .font(.subheadline)
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                                Text(meal.foodItems.joined(separator: ", "))
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(15)
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                        }
                                        
                                        if meals.isEmpty {
                                            Text("No hay comidas registradas hoy")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(Color.white)
                                                .cornerRadius(15)
                                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                        }
                                    }
                                }
                            }

                            struct AddMealView: View {
                                @Environment(\.presentationMode) var presentationMode
                                @State private var mealName = ""
                                @State private var foodItems = ""
                                
                                var body: some View {
                                    NavigationView {
                                        Form {
                                            Section(header: Text("Detalles de la comida")) {
                                                TextField("Nombre (ej. Desayuno, Merienda)", text: $mealName)
                                                TextField("Alimentos (separados por coma)", text: $foodItems)
                                            }
                                        }
                                        .navigationTitle("Añadir comida")
                                        .navigationBarItems(
                                            leading: Button("Cancelar") {
                                                presentationMode.wrappedValue.dismiss()
                                            },
                                            trailing: Button("Guardar") {
                                                saveMeal()
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                            .disabled(mealName.isEmpty || foodItems.isEmpty)
                                        )
                                    }
                                }
                                
                                func saveMeal() {
                                    print("Guardando comida: \(mealName), alimentos: \(foodItems)")
                                    // Aquí implementar la lógica para guardar la comida
                                }
                            }

                            struct WaterIntakeView: View {
                                @State private var waterGlasses = 4
                                
                                var body: some View {
                                    VStack {
                                        HStack {
                                            Text("Hoy has bebido")
                                                .font(.headline)
                                            
                                            Spacer()
                                            
                                            Text("\(waterGlasses) vasos")
                                                .font(.headline)
                                                .foregroundColor(.blue)
                                        }
                                        
                                        HStack(spacing: 10) {
                                            ForEach(0..<8, id: \.self) { index in
                                                Image(systemName: index < waterGlasses ? "drop.fill" : "drop")
                                                    .foregroundColor(.blue)
                                                    .font(.title3)
                                                    .onTapGesture {
                                                        waterGlasses = index + 1
                                                    }
                                            }
                                        }
                                        .padding(.vertical)
                                        
                                        HStack {
                                            Button(action: {
                                                if waterGlasses > 0 {
                                                    waterGlasses -= 1
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(.blue)
                                                    .font(.title2)
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                if waterGlasses < 8 {
                                                    waterGlasses += 1
                                                }
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(.blue)
                                                    .font(.title2)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                }
                            }

