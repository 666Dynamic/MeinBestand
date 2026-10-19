# Mein Bestand — Plan projektu iOS (SwiftUI)

## Kontekst dla asystenta (Claude Code)

Budujemy natywną aplikację iOS w SwiftUI dla **jednego użytkownika** — handlarza
samochodów (nie jest to marketplace ani appka wieloużytkownikowa). Właściciel
kupuje samochody, dokumentuje ich stan i zdjęcia, śledzi inwestycje (naprawy),
oblicza marżę i finalnie sprzedaje pojazd. Appka ma zastąpić dotychczasowy
bałagan: papierowe notatki, zdjęcia porozrzucane w galerii telefonu, brak
szybkiego dostępu do historii serwisowej gdy dzwoni klient.

**Najważniejszy use case:** klient dzwoni i pyta o konkretne auto (olej, przegląd,
liczba właścicieli, liczba kluczy). Handlarz musi w kilka sekund, mając tylko
ostatnie 4 cyfry VIN lub numer inwentarza, znaleźć pojazd i odpowiedzieć —
niezależnie od tego, gdzie akurat jest.

Interfejs (język niemiecki, bo dealer pracuje w DE) został zaprojektowany w
Figmie zgodnie z Apple HIG, z maksymalnym wykorzystaniem natywnych komponentów
iOS (Tab Bar, Segmented Controls, grouped lists, `.ultraThinMaterial` cards).
Zrzuty ekranów i case study są dołączone jako materiał referencyjny — trzymaj
się tej stylistyki, nie wymyślaj nowego designu.

- Wszystkie screenshoty i zdjecia referyncyjne, jak ma wygladac design sa zapisane w /Users/lukas/Developer/MeinBestand/MeinBestand/figma
### Design tokens (z case study)
- Primary: `#0E3FA8` (Deep Cinematic Blue) — nawigacja, branding
- Accent/CTA: `#FFA904` (Radiant Amber) — przyciski akcji, alerty, highlighty
- Typografia: SF Pro (systemowa), standardowe style iOS (LargeTitle, Title1/2/3,
  Headline, Body, Callout, Subheadline, Footnote, Caption)
- Karty: zaokrąglone, `.ultraThinMaterial` / glassmorphism, grouped list style
- Dark mode obowiązkowy (dealer pracuje też w słabym świetle na placu)

### Decyzja: iOS najpierw, web później
Najcenniejsza część appki (skan VIN, zdjęcia z nakładką pozycji) wymaga
natywnego dostępu do kamery — web/PWA da tu gorsze UX. Web dashboard to dobry
pomysł na **etap 2**, gdy dane już siedzą w SwiftData + CloudKit (wtedy backend
może czytać z tej samej bazy). Nie budować webu równolegle na starcie.

---

## Model danych

```swift
@Model
class Vehicle {
    var vin: String
    var marke: String
    var modell: String
    var kraftstoffart: String       // Diesel/Benzin/...
    var leistungPS: Int
    var getriebe: String            // Automatik/Manuell
    var erstzulassung: Date
    var kilometerstand: Int
    var halterAnzahl: Int
    var kommtAn: Date               // data + godzina dostawy
    var vonWo: String               // Herkunft, np. "Auktion"
    var status: VehicleStatus       // .neuzugang, .inLieferung, .onHold, .verkauft
    var einkaufspreis: Decimal
    var verkaufsziel: Decimal
    var tuvDatum: Date?

    @Relationship var photos: [VehiclePhoto]
    @Relationship var damages: [Damage]
    @Relationship var repaints: [RepaintEntry]
    @Relationship var accidents: [AccidentEntry]
    @Relationship var serviceEntries: [ServiceEntry]
    @Relationship var investments: [Investment]
    @Relationship var documents: [Document]
    var schluesselCount: Int
    @Relationship var checklistItems: [ChecklistItem]
    @Relationship var negotiation: Negotiation?
    var notizen: String?

    // computed
    var investitionenGesamt: Decimal { investments.reduce(0) { $0 + $1.kosten } }
    var marge: Decimal { verkaufsziel - einkaufspreis - investitionenGesamt }
    var margePercent: Double { ... }
    var stehzeitTage: Int { Calendar... von kommtAn bis heute }
}

VehiclePhoto { position: PhotoPosition (enum: 14 stałych pozycji — Front,
    VorneLinks, VorneRechts, Hinten, HintenLinks, HintenRechts, Fahrertür,
    Beifahrertür, Rücksitzbank, Mittelkonsole, ...), imageData/fileURL, aufgenommenAm }

Damage { bauteil: String (Stoßstange, Kotflügel, Scheinwerfer...), beschreibung, kosten: Decimal? }
RepaintEntry { bauteil: String, schichtstaerkeMikrometer: Int }
AccidentEntry { jahr: Int, bereich: String (Front/Heck/Seite) }
ServiceEntry { kilometerstand: Int, art: String (Ölwechsel/Bremsen/Digital...), wert: String? }
Investment { bezeichnung: String, kosten: Decimal }
Document { typ: DocumentType (Fahrzeugbrief/Fahrzeugschein/TÜVBericht/CMR), fileURL }
ChecklistItem { titel: String, erledigt: Bool }  // 9 stałych pozycji
Negotiation { mindestpreis: Decimal, scenarios: [PriceScenario] }
PriceScenario { preis: Decimal }  // marge liczona computed

Reminder { typ: ReminderType (TÜV/Stehzeit/Lieferung/Preisanpassung/Service),
    title, description, faelligAm: Date, vehicleID: PersistentIdentifier? }

DealerSettings { haendlername, standort, sprache, waehrung,
    tuvErinnerungTage: Int, lieferungsAlarm, stehzeitAlarmTage: Int,
    preisanpassungTage: Int, serviceErinnerungTage: Int, kaufvertragTemplate: String }
```

Stałe 9 pozycji checklisty (z `Verkaufschecklist.png`):
Schäden dokumentiert, Fotos vollständig, Reifen geprüft, Innenraum gereinigt,
TÜV Aktuell, Alle Schlüssel vorhanden, Kaufvertrag unterschrieben,
Servicehistorie überprüft, Zahlung eingegangen.

---

## Etapy pracy (dla Claude Code)

### Etap 0 — Setup projektu
- Nowy projekt SwiftUI (iOS 17+, target iOS 26 jak w designach)
- 
- SwiftData jako warstwa persystencji, przygotowana pod CloudKit sync
- Struktura nawigacji: `TabView` — Home (Mein Bestand), Erinnerungen,
  Einstellungen; plus `+` floating button do dodania pojazdu i ikona search
- Plik `Theme.swift` z kolorami/fontami z sekcji design tokens

### Etap 1 — Model danych
- Wszystkie encje jako `@Model`, relacje, computed properties opisane wyżej
- Dane testowe (seed) — np. Audi A6, Ford Galaxy, Volvo V60, Mercedes GLA,
  BMW X3 jak w `Mein_Bestand.png`

### Etap 2 — Mein Bestand (lista floty)
- Chips filtrujące: Alle / Neuzugänge / In Lieferung (+ ew. On Hold / Verkauft)
- Karta pojazdu: zdjęcie, badge statusu, marka+model, VIN, data rej. · km ·
  paliwo · skrzynia, cena
- Pusty stan dla kategorii bez pojazdów

### Etap 3 — Kreator przyjęcia pojazdu (wizard, wieloetapowy)
1. **Dane pojazdu**: VIN (pole + przycisk skanera), Marke/Modell/Kraftstoffart/
   Leistung jako pickery, Erstzulassung, Kilometerstand, Halter, Kommt an
   (data+godzina), Einkauf, Verkauf → „Weiter"
2. **Zustand**: lista Hinzufügen-linków (Schäden, Unfall toggle, Nachlackierung,
   TÜV date picker, Servicehistorie, Investitionen, Dokumente, Notizen), każdy
   otwiera sub-sheet (np. dodawanie uszkodzenia: bauteil + opis + koszt)
3. **Fotos**: siatka 2 kolumny, 14 stałych pozycji, każda karta pokazuje
   kontur-placeholder sylwetki auta w odpowiedniej pozycji dopóki nie ma
   zdjęcia; tap otwiera kamerę z nakładką (biały kontur auta + etykieta np.
   "FRONT") pomagającą ustawić kadr
4. Podsumowanie i zapis → przejście do Fahrzeugdetails

### Etap 4 — VIN Scanner
- `VisionKit` / `Vision` text recognition z kamery do odczytu 17-znakowego VIN
- Walidacja formatu VIN (checksum, dozwolone znaki)
- Opcjonalnie: lookup marki/modelu po VIN (uwaga: darmowe API typu NHTSA vPIC
  słabo wspierają auta spoza USA — traktować jako podpowiedź, użytkownik i tak
  potwierdza/poprawia ręcznie)

### Etap 5 — Fahrzeugdetails (hub)
- Karuzela zdjęć (TabView ze stylem page), badge'e "Neuzugänge" / "X Tage
  Stehzeit" (computed z `kommtAn`)
- Grouped list z danymi pojazdu
- Sekcja finansowa: Einkauf, Verkaufsziel, Investitionen (czerwony, ujemny),
  Marge (zielony, z %), link "Kaufvertrag — Generieren"
- Siatka 2×3 linków: Schäden, Investitionen, Servicehistorie, Dokumente,
  Verhandlung, Verkaufschecklist
- Tryb edycji (ołówek w prawym górnym rogu → ikona kosza + checkmark do
  potwierdzenia usunięcia/zmian)

### Etap 6 — Pod-ekrany szczegółowe
- **Schäden**: lista uszkodzeń + osobna sekcja Nachlackierung (μm) + sekcja
  Unfall (rok + obszar)
- **Investitionen**: lista pozycji + suma na dole
- **Servicehistorie**: nagłówek ze statusem (Komplett/Unvollständig) + "Nächster
  Service: Überfällig" warning, grupowanie wpisów po przebiegu (165.000km,
  125.000km...)
- **Dokumente**: Fahrzeugbrief/Fahrzeugschein/TÜV Bericht/CMR z "Anzeigen",
  licznik Schlüssel, przycisk dodawania dokumentu (import z Files/Camera)
- **Verhandlung**: Listenpreis/Mindestpreis/Spielraum (computed), progress bar
  marży przy cenie listowej, lista scenariuszy cenowych z automatycznie
  liczoną marżą i kolorem (zielony/pomarańczowy/czerwony wg progu %)
- **Verkaufschecklist**: 9 stałych pozycji, checkbox, tryb edycji

### Etap 7 — Szybkie wyszukiwanie (priorytet dla realnego problemu użytkownika)
- Dostępne z każdego taba (ikona lupy)
- Wyszukiwanie po: ostatnich 4 cyfrach VIN, pełnym VIN, numerze inwentarza
  (jeśli dodamy to pole), marce/modelu
- Wynik od razu prowadzi do Fahrzeugdetails — to ma działać w 2-3 sekundy od
  otwarcia appki podczas rozmowy telefonicznej

### Etap 8 — Erinnerungen
- Lista przypomnień (ikona, tytuł, opis, godzina)
- Silnik reguł generujący przypomnienia automatycznie z danych pojazdu + ustawień
  z Einstellungen (TÜV -14 dni, Stehzeit +30 dni, Lieferung w dniu, Service -14 dni)
- Lokalne powiadomienia (`UNUserNotificationCenter`)

### Etap 9 — Einstellungen
- Händlername, Standort, Sprache, Währung
- Interwały przypomnień (edytowalne)
- Kaufvertrag Vorlage (edytor szablonu tekstowego z placeholderami)
- Export CSV całej floty
- Backup iCloud (CloudKit, jeśli SwiftData skonfigurowane od Etapu 0)
- "Alle Daten löschen" z potwierdzeniem

### Etap 10 — Kaufvertrag-Generator
- `PDFKit`, szablon wypełniany danymi pojazdu + ceną ustaloną w Verhandlung
- Udostępnianie przez share sheet (AirDrop, Mail, druk)

### Etap 11 — Statystyki (wspomniane na stronie, nie ma w zrzutach UI)
- `Swift Charts`: Umsatz, Ø Marge, Ø Stehzeit, Bestseller (marka/model)
- Osobny tab lub sekcja w Einstellungen/Home

### Etap 12 — Dopracowanie
- Dark mode pełne pokrycie, Dynamic Type, VoiceOver na kluczowych ekranach
- Testy z realnymi numerami VIN (różne marki, EU i spoza EU)
- Obsługa pustych/błędnych stanów (brak zdjęcia, brak internetu przy lookupie VIN)

---

## Kolejność rekomendowana
0 → 1 → 2 → 3 → 5 → 6 → 7 → 4 → 8 → 9 → 10 → 11 → 12

(Wyszukiwanie — etap 7 — warto zrobić zaraz po tym jak dane już się da
wprowadzić ręcznie, żeby jak najszybciej mieć działający Twój główny use case;
VIN scanner, etap 4, można dołożyć później, bo na start wpisywanie VIN ręcznie
w pełni wystarcza do testowania reszty appki.)
