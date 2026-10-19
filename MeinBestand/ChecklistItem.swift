//
 //  ChecklistItem.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class ChecklistItem {
     var titel: String
     var erledigt: Bool

     @Relationship var vehicle: Vehicle?

     init(titel: String = "",
          erledigt: Bool = false) {
         self.titel = titel
         self.erledigt = erledigt
     }
 }