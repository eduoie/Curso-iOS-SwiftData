//
//  Estudiantes.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 18/2/26.
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

struct ContentView: View {

    var body: some View {
        TabView {
            VistaEstudiantes()
                .tabItem {
                    Label("Estudiantes", systemImage: "person.3")
                }
            VistaCursos()
                .tabItem {
                    Label("Cursos", systemImage: "book")
                }
            VistaMatriculas()
                .tabItem {
                    Label("Matrículas", systemImage: "list.bullet.clipboard")
                }
        }
    }
}

struct VistaEstudiantes: View {
    @Environment(\.modelContext) private var context
    @Query private var estudiantes: [Estudiante]
    @State private var mostrarNuevoEstudiante = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(estudiantes) { estudiante in
                    NavigationLink(destination: VistaDetalleEstudiante(estudiante: estudiante)) {
                        VStack(alignment: .leading) {
                            Text(estudiante.nombre)
                                .font(.headline)
                            Text(estudiante.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Cursos: \(estudiante.cursos.count)")
                        }
                    }
                }
                .onDelete { indices in
                    for indice in indices {
                        context.delete(estudiantes[indice])
                    }
                }
            }
            .navigationTitle("Estudiantes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Agregar") {
                        mostrarNuevoEstudiante.toggle()
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevoEstudiante) {
                VistaNuevoEstudiante(context: context)
            }
        }
    }
}

struct VistaDetalleEstudiante: View {
    let estudiante: Estudiante
    @Environment(\.modelContext) private var context
    @State private var mostrarMatricular = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Datos del estudiante
            VStack(alignment: .leading, spacing: 10) {
                Text(estudiante.nombre)
                    .font(.title)
                Text(estudiante.email)
                    .foregroundStyle(.secondary)
                Text("Nacimiento: \(estudiante.fechaNacimiento, style: .date)")
                    .font(.caption)
            }
            .padding()
            
            List {
                Section("Cursos matriculados") {
                    if let matriculas = estudiante.matriculas,
                       !matriculas.isEmpty {
                        ForEach(matriculas) { matricula in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(matricula.curso?.nombre ?? "Sin curso")
                                        .font(.headline)
                                    Text("Semestre: \(matricula.semestre)")
                                        .font(.caption)
                                    if let calificacion = matricula.calificacion {
                                        Text("Calificación: \(calificacion, specifier: "%.2f")")
                                            .font(.caption)
                                            .foregroundStyle(calificacion >= 5.0 ? .green : .red)
                                    }
                                }
                                Spacer()
                                Button("Eliminar") {
                                    context.delete(matricula)
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        }
                        
                    } else {
                        Text("No tiene cursos matriculados")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle("Detalle Estudiante")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Matricular en curso") {
                    mostrarMatricular = true
                }
            }
        }
        .sheet(isPresented: $mostrarMatricular) {
            VistaMatricularEstudiante(estudiante: estudiante)
        }
    }
}

struct VistaMatricularEstudiante: View {
    let estudiante: Estudiante
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query private var cursos: [Curso]
    
    // Necesitamos los cursos en los que no está matriculado
    var cursosNoMatriculados: [Curso] {
        let cursosMatriculados = estudiante.cursos
        return cursos.filter { !cursosMatriculados.contains($0) }
    }
    
    @State private var cursoSeleccionado: Curso?
    @State private var semestre = "2026-1"
    @State private var calificacion: Double?
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Curso", selection: $cursoSeleccionado) {
                    Text("Seleccionar curso")
                        .tag(nil as Curso?)
                    ForEach(cursosNoMatriculados) { curso in
                        Text("\(curso.codigo) - \(curso.nombre)")
                            .tag(curso as Curso?)
                    }
                }
                
                TextField("Semestre", text: $semestre)
                
                TextField("Calificación (opcional)", value: $calificacion, format: .number)
                    .keyboardType(.decimalPad)
                
                Section {
                    Button("Matricular") {
                        guard let curso = cursoSeleccionado else { return }
                        
                        let matricula = Matricula(
                            estudiante: estudiante,
                            curso: curso,
                            semestre: semestre,
                            calificacion: calificacion
                        )
                        
                        context.insert(matricula)
                        dismiss()
                    }
                    .disabled(cursoSeleccionado == nil || semestre.isEmpty)
                }
                
            }
            .navigationTitle("Nueva matrícula")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}



struct VistaCursos: View {
    @Query private var cursos: [Curso]
    @State private var mostrarNuevoCurso = false
    
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
                VistaNuevoCurso()
            }
        }
    }
}

struct VistaNuevoCurso: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var codigo = ""
    @State private var nombre = ""
    @State private var creditos = 3
    @State private var profesor = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Código", text: $codigo)
                TextField("Nombre", text: $nombre)
                Stepper("Créditos: \(creditos)", value: $creditos, in: 1...10)
                TextField("Profesor", text: $profesor)
            }
            .navigationTitle("Nuevo curso")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let curso = Curso(
                            codigo: codigo,
                            nombre: nombre,
                            creditos: creditos,
                            profesor: profesor
                        )
                        context.insert(curso)
                        dismiss()
                    }
                    .disabled(codigo.isEmpty || nombre.isEmpty || profesor.isEmpty)
                }
            }
        }
    }
}




#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Estudiante.self,
        Curso.self,
        Matricula.self,
        configurations: config
    )
    
    crearDatosEjemplo(container: container)

    return ContentView()
        .modelContainer(container)
}

func crearDatosEjemplo(container: ModelContainer) {
    let context = ModelContext(container)
    
    let estudiante1 = Estudiante(
        nombre: "Ana García",
        email: "ana.garcia@uni.edu",
        fechaNacimiento: Calendar.current.date(from: DateComponents(year: 1990, month: 5, day: 15))!
    )

    let estudiante2 = Estudiante(
        nombre: "Carlos Pérez",
        email: "carlos.perez@uni.edu",
        fechaNacimiento: Calendar.current.date(from: DateComponents(year: 2000, month: 2, day: 11))!
    )
    
    let curso1 = Curso(
        codigo: "CAL101", nombre: "Cálculo I", creditos: 4, profesor: "Sr. Gómez"
    )
    
    let curso2 = Curso(
        codigo: "SWF1", nombre: "Intro a Swift", creditos: 3, profesor: "Sr. Eduardo"
    )
    
    let matricula1 = Matricula(
        estudiante: estudiante1,
        curso: curso1,
        semestre: "2026-1",
        calificacion: 8.5
    )
    
    let matricula2 = Matricula(
        estudiante: estudiante1,
        curso: curso2,
        semestre: "2026-1"
    )
    
    let matricula3 = Matricula(
        estudiante: estudiante2,
        curso: curso1,
        semestre: "2025-1",
        calificacion: 3
    )
    
    context.insert(estudiante1)
    context.insert(estudiante2)
    
    context.insert(curso1)
    context.insert(curso2)
    
    context.insert(matricula1)
    context.insert(matricula2)
    context.insert(matricula3)
    
    // Persistir los cambios manualmente (para que funcione en la Preview)
    try? context.save()
}
