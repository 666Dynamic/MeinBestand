//
 //  AccidentEntry.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class AccidentEntry {
     var jahr: Int
     var bereich: String   // Front/Heck/Seite

     @Relationship var vehicle: Vehicle?

     init(jahr: Int = 0,
          bereich: String = "") {
         self.jahr = jahr
         self.bereich = bereich
     }
 }