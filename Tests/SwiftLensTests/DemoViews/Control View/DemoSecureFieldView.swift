struct DemoSecureFieldView: View {
    
    @State private var passwordText = ""
    
    var body: some View {
        VStack {
            Text("other text")
            SecureField("Enter password", text: $passwordText)
                .lensSecureTextField(id: "demo_securefield",
                                     text: $passwordText)
        }
    }
}