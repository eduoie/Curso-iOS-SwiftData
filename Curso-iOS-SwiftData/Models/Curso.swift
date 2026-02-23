//
//  Curso.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 23/2/26.
//


import SwiftData
import SwiftUI

@Model
class Curso {
    var id: UUID
    var codigo: String
    var nombre: String
    var creditos: Int
    var profesor: String

    // Relación 1 a muchos: Un curso puede tener MÚLTIPLES matrículas
    @Relationship(deleteRule: .nullify)  // si borramos el curso, las matrículas se quedan sin curso
    var matriculas: [Matricula]?

    // Relación muchos a muchos: Un curso tiene muchos estudiantes
    // y los estudiantes se matriculan en muchos cursos.
    var estudiantes: [Estudiante] {
        return matriculas?.compactMap { $0.estudiante } ?? []
    }

    init(codigo: String, nombre: String, creditos: Int, profesor: String) {
        self.id = UUID()
        self.codigo = codigo
        self.nombre = nombre
        self.creditos = creditos
        self.profesor = profesor
        self.matriculas = []
    }
}