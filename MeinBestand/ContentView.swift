//
 //  ContentView.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import SwiftUI

 struct ContentView: View {
     var body: some View {
         TabView {
             HomeView()
                 .tabItem {
                     Label("Mein Bestand", systemImage: "car")
                 }

             ErinnerungenView()
                 .tabItem {
                     Label("Erinnerungen", systemImage: "bell")
                 }

             EinstellungenView()
                 .tabItem {
                     Label("Einstellungen", systemImage: "gear")
                 }
         }
         .accentColor(Theme.accent)
     }
 }

 // MARK: - Home View
 struct HomeView: View {
     @State private var searchText = ""

     var body: some View {
         NavigationStack {
             VStack {
                 // Placeholder for vehicle list
                 List {
                     Text("Keine Fahrzeuge vorhanden")
                         .foregroundColor(.secondary)
                         .listRowBackground(Color.clear)
                 }
                 .listStyle(.plain)
                 .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                 .navigationTitle("Mein Bestand")
                 .toolbar {
                     ToolbarItem(placement: .navigationBarTrailing) {
                         Button(action: addVehicle) {
                             Image(systemName: "plus")
                                 .font(.title2)
                         }
                     }
                 }
             }
         }
     }

     private func addVehicle() {
         // TODO: Implement vehicle creation
     }
 }

 // MARK: - Erinnerungen View
 struct ErinnerungenView: View {
     var body: some View {
         Text("Erinnerungen")
             .font(Theme.title2)
             .frame(maxWidth: .infinity, maxHeight: .infinity)
             .background(Color(.systemGroupedBackground))
     }
 }

 // MARK: - Einstellungen View
 struct EinstellungenView: View {
     var body: some View {
         Text("Einstellungen")
             .font(Theme.title2)
             .frame(maxWidth: .infinity, maxHeight: .infinity)
             .background(Color(.systemGroupedBackground))
     }
 }