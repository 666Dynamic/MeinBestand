//
 //  PriceScenario.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class PriceScenario {
     var preis: Decimal

     @Relationship var negotiation: Negotiation?

     init(preis: Decimal = 0) {
         self.preis = preis
     }
 }