//
//  ForgotPassView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI

struct ForgotPassView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Forgot Password")
                .font(.title3)
                .fontWeight(.semibold)
            
            TextField("Enter your email", text: $email)
                .font(.subheadline)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
                .autocapitalization(.none)
            
            Button {
                
            } label: {
                Text("Send Code")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 352, height: 44)
                    .background(Color(hex: "398378"))
                    .cornerRadius(8)
            }
            
            Button {
                dismiss()
            } label: {
                Text("Back to Log In")
                    .foregroundColor(Color(hex: "31C48D"))
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .padding()
            }
            
            Spacer()
            
        }
    }
}
