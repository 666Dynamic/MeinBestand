//
 //  RepaintEntry.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class RepaintEntry {
     var bauteil: String
     var schichtstaerkeMikrometer: Int   // μm

     @Relationship var vehicle: Vehicle?

     init(bauteil: String = "",
          schichtstaerkeMikrometer: Int = 0) {
         self.bauteil = bauteil
         self.schichtstaerkeMikrometer = schichtstaerkeMikrometer
     }
 }