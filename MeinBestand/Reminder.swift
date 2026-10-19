//
//  Reminder.swift
//  MeinBestand
//
//  Created by Lukas on 19.10.26.
//

import Foundation
import SwiftData

@Model
class Reminder {
    var typ: ReminderType
    var title: String
    var erinnerungBeschreibung: String
    var faelligAm: Date
    @Relationship var vehicle: Vehicle? // optional link to vehicle

    init(typ: ReminderType = .tuv,
         title: String = "",
         description: String = "",
         faelligAm: Date = Date()) {
        self.typ = typ
        self.title = title
        self.erinnerungBeschreibung = description
        self.faelligAm = faelligAm
    }
}
