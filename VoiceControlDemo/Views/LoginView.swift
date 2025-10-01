//
//  LoginView.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "cat.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.orange)

            Text("Cat Browser")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 20) {
                // ISSUE: No accessibility label
                // ISSUE: Missing textContentType
                TextField("", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        Text(username.isEmpty ? "Username" : "")
                            .foregroundColor(.gray)
                            .padding(.leading, 16)
                            .allowsHitTesting(false),
                        alignment: .leading
                    )

                // ISSUE: No accessibility label
                // ISSUE: Missing textContentType for password
                SecureField("", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        Text(password.isEmpty ? "Password" : "")
                            .foregroundColor(.gray)
                            .padding(.leading, 16)
                            .allowsHitTesting(false),
                        alignment: .leading
                    )

                // ISSUE: Not a button - using Text with tap gesture
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .onTapGesture {
                        // Simple "login" - just accept any input
                        if !username.isEmpty && !password.isEmpty {
                            isLoggedIn = true
                        }
                    }
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
