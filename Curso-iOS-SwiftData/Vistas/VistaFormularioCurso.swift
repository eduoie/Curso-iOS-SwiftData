import SwiftData
import SwiftUI

struct VistaFormularioCurso: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: FormularioCursoViewModel
    
    init(context: ModelContext, curso: Curso? = nil) {
        _viewModel = State(initialValue: FormularioCursoViewModel(context: context, curso: curso))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Código", text: $viewModel.codigo)
                TextField("Nombre", text: $viewModel.nombre)
                Stepper("Créditos: \(viewModel.creditos)", value: $viewModel.creditos, in: 1...10)
                TextField("Profesor", text: $viewModel.profesor)
            }
            .navigationTitle(viewModel.titulo)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.esEdicion ? "Actualizar" : "Crear") {
                        viewModel.guardar()
                        dismiss()
                    }
                    .disabled(!viewModel.esValido)
                }
            }
        }
    }
}
