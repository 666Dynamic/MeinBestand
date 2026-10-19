//
//  MeinBestandApp.swift
//  MeinBestand
//
//  Created by Lukas on 19.10.26.
//

import SwiftUI
import SwiftData

@main
struct MeinBestandApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Vehicle.self, Reminder.self, DealerSettings.self])
    }
}
