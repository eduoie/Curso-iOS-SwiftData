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
            
            let filtroAprobadas = #Predicate<Matricula> { matricula in
                (matricula.calificacion ?? 0.0) >= 5.0
            }
            let descriptorAprobadas = FetchDescriptor<Matricula>(
                predicate: filtroAprobadas,
                sortBy: [SortDescriptor(\.fechaMatricula, order: .reverse)]
            )
            matriculasAprobadas = try context.fetch(descriptorAprobadas)
            
            if let nombreABuscar = nombreAlumno {
                let filtroAlumno = #Predicate<Matricula> { matricula in
                    matricula.estudiante?.nombre.contains(nombreABuscar) == true
                }
                let descriptorAlumnos = FetchDescriptor<Matricula>(predicate: filtroAlumno)
                matriculasDeAlumno = try context.fetch(descriptorAlumnos)
            }
            
        } catch {
            print("Error cargando matrículas: \(error)")
        }
    }
    
    func eliminarMatricular(matricula: Matricula) {
        context.delete(matricula)
        // Hay que recargar los arrays para que la UI se entere que hemos borrado
        cargarDatos()
    }
    
}
