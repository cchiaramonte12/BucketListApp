//
//  RegistrationView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @StateObject var viewModel = RegistrationViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                
                TextField("Enter your full name", text: $viewModel.fullname)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                
                TextField("Enter your username", text: $viewModel.username)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    .autocapitalization(.none)
            }
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 352, height: 44)
                    .background(Color(hex: "398378"))
                    .cornerRadius(8)
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button(action: {
                dismiss()
            }, label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                        .foregroundColor(.black)
                    
                    Text("Log In")
                        .foregroundColor(Color(hex: "398378"))
                        .fontWeight(.semibold)
                }
                .font(.footnote)
            })
            .padding(.vertical, 16)
        }
    }
}
