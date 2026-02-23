//
//  FormularioCursoViewModel.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 23/2/26.
//

import SwiftUI
import SwiftData

@Observable
class FormularioCursoViewModel {
    var codigo = ""
    var nombre = ""
    var creditos = 3
    var profesor = ""
    
    // Si es nil -> Estamos creando un curso nuevo
    // Si no es nil -> Estamos editando un curso
    private var cursoExistente: Curso?
    
    private var context: ModelContext
    
    init(context: ModelContext, curso: Curso? = nil) {
        self.context = context
        cursoExistente = curso
        
        if let curso = curso {
            codigo = curso.codigo
            nombre = curso.nombre
            creditos = curso.creditos
            profesor = curso.profesor
        }
    }
    
    var esEdicion: Bool {
        cursoExistente != nil
    }
    
    var titulo: String {
        esEdicion ? "Editar Curso" : "Nuevo Curso"
    }
    
    var esValido: Bool {
        !codigo.isEmpty && !nombre.isEmpty && !profesor.isEmpty
    }
    
    func guardar() {
        if let curso = cursoExistente {
            curso.codigo = codigo
            curso.nombre = nombre
            curso.creditos = creditos
            curso.profesor = profesor
        } else {
            let nuevoCurso = Curso(
                codigo: codigo,
                nombre: nombre,
                creditos: creditos,
                profesor: profesor
            )
            context.insert(nuevoCurso)
        }
    }
    
}
