//
//  VistaMatriculas.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 20/2/26.
//


import SwiftData
import SwiftUI

struct VistaMatriculas: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var viewModel: MatriculasViewModel
    
    init(context: ModelContext) {
        _viewModel = State(initialValue: MatriculasViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Todas las matrículas") {
                    ForEach(viewModel.todasLasMatriculas) { matricula in
                        VStack(alignment: .leading) {
                            Text("\(matricula.estudiante?.nombre ?? "N/A") - \(matricula.curso?.nombre ?? "N/A")")
                            Text("Semestre: \(matricula.semestre)")
                        }
                    }
                    .onDelete { indices in
                        indices.forEach { indice in
                            let matricula = viewModel.todasLasMatriculas[indice]
                            viewModel.eliminarMatricular(matricula: matricula)
                        }
                    }
                }
                
                Section("Matrículas aprobadas") {
                    ForEach(viewModel.matriculasAprobadas) { matricula in
                        Text("\(matricula.estudiante?.nombre ?? "N/A") - \(matricula.calificacion ?? 0.0, specifier: "%.2f")")
                    }
                }
                
                Section("Matrículas de un alumno concreto") {
                    ForEach(viewModel.matriculasDeAlumno) { matricula in
                        Text("\(matricula.estudiante?.nombre ?? "N/A") - \(matricula.calificacion ?? 0.0, specifier: "%.2f")")
                    }
                }
            }
            
            .navigationTitle("Matrículas")
            
            .onAppear {
                viewModel.cargarDatos(nombreAlumno: "Carlos")
            }
        }
    }
}
