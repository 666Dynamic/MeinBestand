//
 //  Damage.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class Damage {
     var bauteil: String       // e.g., Stoßstange, Kotflügel, Scheinwerfer
     var beschreibung: String
     var kosten: Decimal?      // optional cost

     @Relationship var vehicle: Vehicle?

     init(bauteil: String = "",
          beschreibung: String = "",
          kosten: Decimal? = nil) {
         self.bauteil = bauteil
         self.beschreibung = beschreibung
         self.kosten = kosten
     }
 }