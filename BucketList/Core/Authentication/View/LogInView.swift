//
//  LogInView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct LogInView: View {
    
    @StateObject var viewModel = LogInViewModel()
    
    //@EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Image("bucket-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 120)
                    .padding()
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                        .autocapitalization(.none)
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                        .autocapitalization(.none)
                }
                
                NavigationLink {
                    ForgotPassView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .padding(.trailing, 28)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Button {
                    Task { try await viewModel.login() }
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(Color(hex: "398378"))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .foregroundColor(.black)
                        
                        Text("Sign Up")
                            .foregroundColor(Color(hex: "398378"))
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
        }
    }
}

// Extension to use Hex codes for colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in:CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
        (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .displayP3,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


/**        VStack {
 Text("Welcome")
 Button(action: {
     appState.needsToLogIn = false
 }, label: {
     Text("Log In")
 })
}*/
