struct VistaNuevoEstudiante: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var nombre = ""
    @State private var email = ""
    @State private var fechaNacimiento = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $nombre)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                DatePicker("Fecha de nacimiento",
                        selection: $fechaNacimiento,
                        displayedComponents: .date)
            }
            .navigationTitle("Nuevo estudiante")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let estudiante = Estudiante(
                            nombre: nombre,
                            email: email,
                            fechaNacimiento: fechaNacimiento
                        )
                        context.insert(estudiante)
                        dismiss()
                    }
                    .disabled(nombre.isEmpty || email.isEmpty)
                }
            }
        }
    }
}
