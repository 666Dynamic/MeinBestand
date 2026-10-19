//
 //  Investment.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class Investment {
     var bezeichnung: String
     var kosten: Decimal

     @Relationship var vehicle: Vehicle?

     init(bezeichnung: String = "",
          kosten: Decimal = 0) {
         self.bezeichnung = bezeichnung
         self.kosten = kosten
     }
 }