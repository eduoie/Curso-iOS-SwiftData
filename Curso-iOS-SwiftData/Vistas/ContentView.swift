//
//  ContentView.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 23/2/26.
//


import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(\.modelContext) private var context
    
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
            VistaMatriculas(context: context)
                .tabItem {
                    Label("Matrículas", systemImage: "list.bullet.clipboard")
                }
        }
    }
}