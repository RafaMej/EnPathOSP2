//
//  Models.swift
//  EnPathOS
//
//  Created by Rafael Mejía López on 02/04/25.
//
import SwiftUI
import SwiftData
import AVKit
import CoreLocation
import UserNotifications

struct User: Identifiable {
    var id: String
    var name: String
    var age: Int
    var role: UserRole
    var emergencyContacts: [Contact]
}

enum UserRole {
    case senior
    case caregiver
}

struct Contact: Identifiable {
    var id: String
    var name: String
    var phone: String
    var relation: String
}

struct MedicalRecord: Identifiable {
    var id: String
    var date: Date
    var title: String
    var details: String
    var diagnosis: String
    var medications: String
    var notes: String
    var hasAttachment: Bool
}

struct Reminder: Identifiable {
    var id: String
    var title: String
    var description: String
    var time: Date
    var isDaily: Bool
    var isCompleted: Bool = false
}

struct Appointment: Identifiable {
    var id: String
    var title: String
    var doctor: String
    var location: String
    var date: Date
    var notes: String
}

struct WellnessEntry: Identifiable {
    var id: String
    var date: Date
    var mood: Int // 1-5
    var exercise: Int // minutos
    var meals: [Meal]
    var notes: String
}

struct Meal: Identifiable {
    var id: String
    var name: String
    var time: Date
    var foodItems: [String]
}

struct CognitiveGame: Identifiable {
    var id: String
    var name: String
    var description: String
    var difficulty: Int // 1-5
    var type: GameType
}

enum GameType {
    case memory
    case logic
    case language
}
