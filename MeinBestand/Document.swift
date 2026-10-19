//
 //  Document.swift
 //  MeinBestand
 //
 //  Created by Lukas on 19.10.26.
 //

 import Foundation
 import SwiftData

 @Model
 class Document {
     var typ: DocumentType
     var fileURL: String

     @Relationship var vehicle: Vehicle?

     init(typ: DocumentType = .fahrzeugbrief,
          fileURL: String = "") {
         self.typ = typ
         self.fileURL = fileURL
     }
 }