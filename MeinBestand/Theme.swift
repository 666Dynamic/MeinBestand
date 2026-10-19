//
 //  Theme.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import SwiftUI

 struct Theme {
     // MARK: - Colors
     static let primary = Color(hex: 0x0E3FA8) // Deep Cinematic Blue
     static let accent = Color(hex: 0xFFA904)  // Radiant Amber

     // MARK: - Typography
     // Using system fonts (SF Pro) with standard text styles
     static let title1 = Font.system(size: 28, weight: .bold, design: .default)
     static let title2 = Font.system(size: 22, weight: .bold, design: .default)
     static let title3 = Font.system(size: 20, weight: .bold, design: .default)
     static let headline = Font.system(size: 17, weight: .semibold, design: .default)
     static let body = Font.system(size: 17, weight: .regular, design: .default)
     static let callout = Font.system(size: 16, weight: .regular, design: .default)
     static let subheadline = Font.system(size: 15, weight: .semibold, design: .default)
     static let footnote = Font.system(size: 13, weight: .regular, design: .default)
     static let caption = Font.system(size: 12, weight: .regular, design: .default)
 }

 // MARK: - Hex Color Init
 extension Color {
     init(hex: UInt32, opacity: Double = 1.0) {
         let red = Double((hex & 0xFF0000) >> 16) / 255.0
         let green = Double((hex & 0x00FF00) >> 8) / 255.0
         let blue = Double(hex & 0x0000FF) / 255.0
         self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
     }
 }