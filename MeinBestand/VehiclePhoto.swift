//
 //  VehiclePhoto.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class VehiclePhoto {
     var position: PhotoPosition
     var imageData: Data?        // alternatively fileURL could be stored as String or URL
     var fileURL: String?        // store as string path or UUID reference
     var aufgenommenAm: Date

     @Relationship var vehicle: Vehicle?

     init(position: PhotoPosition = .front,
          imageData: Data? = nil,
          fileURL: String? = nil,
          aufgenommenAm: Date = Date()) {
         self.position = position
         self.imageData = imageData
         self.fileURL = fileURL
         self.aufgenommenAm = aufgenommenAm
     }
 }