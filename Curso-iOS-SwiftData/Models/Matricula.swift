//
//  Matricula.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 23/2/26.
//


import SwiftData
import SwiftUI

@Model
class Matricula {
    var id: UUID
    var fechaMatricula: Date
    var calificacion: Double?
    var semestre: String

    // Relación muchos a 1:
    // Un estudiante puede tener varias matrículas
    // cada matrícula pertenece a UN estudiante.
    var estudiante: Estudiante?

    // Relación muchos a 1: cada matrícula es para UN curso
    var curso: Curso?

    init(
        estudiante: Estudiante? = nil,
        curso: Curso? = nil,
        semestre: String,
        calificacion: Double? = nil
    ) {

        self.id = UUID()
        self.fechaMatricula = Date()
        self.semestre = semestre
        self.calificacion = calificacion
        self.estudiante = estudiante
        self.curso = curso
    }
}