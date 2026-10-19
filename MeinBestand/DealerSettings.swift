//
 //  DealerSettings.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class DealerSettings {
     var haendlername: String
     var standort: String
     var sprache: String
     var waehrung: String
     var tuvErinnerungTage: Int
     var lieferungsAlarm: Bool   // czy włączone przypomnienie o dostawie
     var stehzeitAlarmTage: Int
     var preisanpassungTage: Int
     var serviceErinnerungTage: Int
     var kaufvertragTemplate: String

     init(haendlername: String = "",
          standort: String = "",
          sprache: String = "de",
          waehrung: String = "EUR",
          tuvErinnerungTage: Int = 14,
          lieferungsAlarm: Bool = true,
          stehzeitAlarmTage: Int = 30,
          preisanpassungTage: Int = 30,
          serviceErinnerungTage: Int = 14,
          kaufvertragTemplate: String = "") {
         self.haendlername = haendlername
         self.standort = standort
         self.sprache = sprache
         self.waehrung = waehrung
         self.tuvErinnerungTage = tuvErinnerungTage
         self.lieferungsAlarm = lieferungsAlarm
         self.stehzeitAlarmTage = stehzeitAlarmTage
         self.preisanpassungTage = preisanpassungTage
         self.serviceErinnerungTage = serviceErinnerungTage
         self.kaufvertragTemplate = kaufvertragTemplate
     }
 }