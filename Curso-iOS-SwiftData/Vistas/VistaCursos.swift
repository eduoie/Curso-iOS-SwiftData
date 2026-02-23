//
//  VistaCursos.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 23/2/26.
//


import SwiftData
import SwiftUI

struct VistaCursos: View {
    @Environment(\.modelContext) private var context

    @Query private var cursos: [Curso]
    @State private var mostrarNuevoCurso = false
    @State private var cursoSeleccionado: Curso?

    var body: some View {
        NavigationStack {
            List {
                ForEach(cursos) { curso in
                    VStack(alignment: .leading) {
                        Text(curso.nombre)
                            .font(.headline)
                        Text("Código: \(curso.codigo)")
                            .font(.caption)
                        Text("Profesor: \(curso.profesor)")
                            .font(.caption)
                        Text("Estudiantes: \(curso.estudiantes.count)")
                            .font(.caption)
                    }
                    .onTapGesture {
                        cursoSeleccionado = curso
                    }
                }
            }
            
            .navigationTitle("Cursos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Agregar") {
                        mostrarNuevoCurso = true
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevoCurso) {
                VistaFormularioCurso(context: context)
            }
            .sheet(item: $cursoSeleccionado) { curso in
                VistaFormularioCurso(context: context, curso: curso)
            }
        }
    }
}
