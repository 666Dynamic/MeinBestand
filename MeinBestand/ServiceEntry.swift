//
 //  ServiceEntry.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class ServiceEntry {
     var kilometerstand: Int
     var art: String       // Ölwechsel/Bremsen/Digital...
     var wert: String?     // optional value

     @Relationship var vehicle: Vehicle?

     init(kilometerstand: Int = 0,
          art: String = "",
          wert: String? = nil) {
         self.kilometerstand = kilometerstand
         self.art = art
         self.wert = wert
     }
 }