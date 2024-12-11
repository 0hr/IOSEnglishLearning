//
//  Alert.swift
//  smartlanguagelearning
//
//  Created by Harun Rasit Pekacar on 11/10/24.
//

import SwiftUI

public struct Alert: View {
    let geometry: GeometryProxy
    let message: String
    @Binding var showError: Bool
    public var body: some View {
        if showError {
            VStack {
                Spacer()
                Button(action: closeAlert) {
                    HStack {
                        Text(message)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.red.opacity(1), lineWidth: 1)
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.red.opacity(0.5), radius: 20)
                    .transition(.move(edge: .bottom))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, geometry.size.height * 0.04)
            .animation(.spring(), value: showError)
        }
    }
    
    func closeAlert() {
        showError = false
    }
}

#Preview {
    @Previewable @State var showError: Bool = true
    GeometryReader { geometry in
        Alert(geometry: geometry, message: "test", showError: $showError)
    }
}
