//
//  SecureInputView.swift
//  Syriana
//
//  Created by Fady Basem on 9/11/22.
//

import SwiftUI

struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    private var prompt: Text
    
    init(_ title: String, text: Binding<String>, prompt: Text) {
        self.title = title
        self._text = text
        self.prompt = prompt
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text, prompt: prompt)
                } else {
                    TextField(title, text: $text)
                }
            }.padding(.trailing, 32)

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}
