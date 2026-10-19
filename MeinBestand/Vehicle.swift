//
//  Vehicle.swift
//  MeinBestand
//
//  Created by Lukas on 19.10.26.
//

import Foundation
import SwiftData

@Model
class Vehicle {
    var vin: String
    var marke: String
    var modell: String
    var kraftstoffart: String
    var leistungPS: Int
    var getriebe: String
    var erstzulassung: Date
    var kilometerstand: Int
    var halterAnzahl: Int
    var kommtAn: Date
    var vonWo: String
    var status: VehicleStatus
    var einkaufspreis: Decimal
    var verkaufsziel: Decimal
    var tuvDatum: Date?

    @Relationship var photos: [VehiclePhoto] = []
    @Relationship var damages: [Damage] = []
    @Relationship var repaints: [RepaintEntry] = []
    @Relationship var accidents: [AccidentEntry] = []
    @Relationship var serviceEntries: [ServiceEntry] = []
    @Relationship var investments: [Investment] = []
    @Relationship var documents: [Document] = []
    var schluesselCount: Int
    @Relationship var checklistItems: [ChecklistItem] = []
    @Relationship var negotiation: Negotiation?
    @Relationship var reminders: [Reminder] = []
    var notizen: String?

    // MARK: - Computed Properties
    var investitionenGesamt: Decimal {
        investments.reduce(into: Decimal(0)) { $0 += $1.kosten }
    }

    var marge: Decimal {
        verkaufsziel - einkaufspreis - investitionenGesamt
    }

    var margePercent: Double {
        guard verkaufsziel != 0 else { return 0 }
        return NSDecimalNumber(decimal: marge).doubleValue
            / NSDecimalNumber(decimal: verkaufsziel).doubleValue * 100.0
    }

    var stehzeitTage: Int {
        Calendar.current.dateComponents([.day], from: kommtAn, to: Date()).day ?? 0
    }

    // MARK: - Initializer
    init(vin: String = "",
         marke: String = "",
         modell: String = "",
         kraftstoffart: String = "",
         leistungPS: Int = 0,
         getriebe: String = "",
         erstzulassung: Date = Date(),
         kilometerstand: Int = 0,
         halterAnzahl: Int = 0,
         kommtAn: Date = Date(),
         vonWo: String = "",
         status: VehicleStatus = .neuzugang,
         einkaufspreis: Decimal = 0,
         verkaufsziel: Decimal = 0,
         tuvDatum: Date? = nil,
         schluesselCount: Int = 0,
         notizen: String? = nil) {
        self.vin = vin
        self.marke = marke
        self.modell = modell
        self.kraftstoffart = kraftstoffart
        self.leistungPS = leistungPS
        self.getriebe = getriebe
        self.erstzulassung = erstzulassung
        self.kilometerstand = kilometerstand
        self.halterAnzahl = halterAnzahl
        self.kommtAn = kommtAn
        self.vonWo = vonWo
        self.status = status
        self.einkaufspreis = einkaufspreis
        self.verkaufsziel = verkaufsziel
        self.tuvDatum = tuvDatum
        self.schluesselCount = schluesselCount
        self.notizen = notizen
    }
}

// MARK: - Enums
enum VehicleStatus: String, Codable, CaseIterable, Identifiable {
    case neuzugang = "Neuzugang"
    case inLieferung = "In Lieferung"
    case onHold = "On Hold"
    case verkauft = "Verkauft"

    var id: String { rawValue }
}

enum PhotoPosition: String, Codable, CaseIterable, Identifiable {
    case front = "Front"
    case frontLeft = "VorneLinks"
    case frontRight = "VorneRechts"
    case rear = "Hinten"
    case rearLeft = "HintenLinks"
    case rearRight = "HintenRechts"
    case driverDoor = "Fahrertür"
    case passengerDoor = "Beifahrertür"
    case rearSeat = "Rücksitzbank"
    case centerConsole = "Mittelkonsole"
    case roof = "Dach"
    case hood = "Motorhaube"
    case trunk = "Kofferraum"
    case wheel = "Felge"

    var id: String { rawValue }
}

enum DocumentType: String, Codable, CaseIterable, Identifiable {
    case fahrzeugbrief = "Fahrzeugbrief"
    case fahrzeugschein = "Fahrzeugschein"
    case tuvBericht = "TÜVBericht"
    case cmr = "CMR"

    var id: String { rawValue }
}

enum ReminderType: String, Codable, CaseIterable, Identifiable {
    case tuv = "TÜV"
    case stehzeit = "Stehzeit"
    case lieferung = "Lieferung"
    case preisanpassung = "Preisanpassung"
    case service = "Service"

    var id: String { rawValue }
}
