//
//  Estudiante.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 23/2/26.
//


import SwiftData
import SwiftUI

@Model
class Estudiante {
    var id: UUID
    var nombre: String
    var email: String
    var fechaNacimiento: Date

    // Relación 1 a muchos: Un estudiante puede tener múltiples matrículas (0..N)
    @Relationship(deleteRule: .cascade)  // si se borra el estudiante se borran sus matrículas
    var matriculas: [Matricula]?

    // Propiedad computada para obtener los cursos (a través de Matriculas)
    var cursos: [Curso] {
        matriculas?.compactMap { $0.curso } ?? []
    }

    init(nombre: String, email: String, fechaNacimiento: Date) {
        self.id = UUID()
        self.nombre = nombre
        self.email = email
        self.fechaNacimiento = fechaNacimiento
        self.matriculas = []
    }
}