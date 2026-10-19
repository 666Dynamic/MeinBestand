//
 //  Negotiation.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class Negotiation {
     var mindestpreis: Decimal
     @Relationship var scenarios: [PriceScenario] = []

     @Relationship var vehicle: Vehicle?

     init(mindestpreis: Decimal = 0) {
         self.mindestpreis = mindestpreis
     }
 }