//
//  UserBlockedView.swift
//  Syriana
//
//  Created by Fady Basem on 9/22/22.
//

import SwiftUI

struct UserBlockedView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                .frame(width: 110, height: 100)
                .padding()
                
                Text("Oops... Something went wrong")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                
                Text("Seems like your account was blocked. Please visit Syriana center to solve this problem.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button {
                    exit(0)
                } label: {
                    Label("Exit", image: "arrow.clockwise")
                        .foregroundColor(Color("BackgroundColor"))
                }
                .padding(.horizontal, 75)
                .padding(.vertical, 25)
                .background(Color("ThemeColor"))
                .cornerRadius(50)
            }
        }
    }
}

struct UserBlockedView_Previews: PreviewProvider {
    static var previews: some View {
        UserBlockedView()
    }
}
