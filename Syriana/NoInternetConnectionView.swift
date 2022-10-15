//
//  NoInternetConnectionView.swift
//  Syriana
//
//  Created by Fady Basem on 9/22/22.
//

import SwiftUI

struct NoInternetConnectionView: View {
    @Binding var tryAgainAction: () -> ()
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("NoWifiIcon")
                    .padding()
                
                Text("No Internet Connection")
                    .font(.title)
                    .bold()
                
                Text("Failed to connect to Syriana. Please check your internet  connection and try again.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button {
                    tryAgainAction()
                } label: {
                    Label("Try Again", image: "arrow.clockwise")
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

struct NoInternetConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetConnectionView(tryAgainAction: .constant({
            
        }))
    }
}
