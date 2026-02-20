//
//  MatriculasViewModel.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 20/2/26.
//

import SwiftUI
import SwiftData

@Observable
class MatriculasViewModel {
    var todasLasMatriculas: [Matricula] = []
    var matriculasAprobadas: [Matricula] = []
    var matriculasDeAlumno: [Matricula] = []
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        cargarDatos()
    }
    
    func cargarDatos(nombreAlumno: String? = nil) {
        do {
            let descriptorTodas = FetchDescriptor<Matricula>(
                sortBy: [SortDescriptor(\.fechaMatricula, order: .reverse)]
            )
            todasLasMatriculas = try context.fetch(descriptorTodas)
            
        } catch {
            print("Error cargando matrículas: \(error)")
        }
    }
    
}
