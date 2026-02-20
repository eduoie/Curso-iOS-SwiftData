//
//  VistaMatriculas.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 20/2/26.
//


import SwiftData
import SwiftUI

struct VistaMatriculas: View {
    @Query(sort: \Matricula.fechaMatricula, order: .reverse)
    private var matriculas: [Matricula]
    
    @Query(filter: #Predicate<Matricula> {
        ($0.calificacion ?? 0.0) >= 5.0
    })
    private var matriculasAprobadas: [Matricula]
    
    @Query(filter: #Predicate<Matricula> {
        $0.estudiante?.nombre.contains("Ana") == true
    })
    private var matriculasDeAna: [Matricula]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Todas las matrículas") {
                    ForEach(matriculas) { matricula in
                        VStack(alignment: .leading) {
                            Text("\(matricula.estudiante?.nombre ?? "N/A") - \(matricula.curso?.nombre ?? "N/A")")
                            Text("Semestre: \(matricula.semestre)")
                        }
                    }
                }
                
                Section("Matrículas aprobadas") {
                    ForEach(matriculasAprobadas) { matricula in
                        Text("\(matricula.estudiante?.nombre ?? "N/A") - \(matricula.calificacion ?? 0.0, specifier: "%.2f")")
                    }
                }
            }
            
            .navigationTitle("Matrículas")
        }
    }
}