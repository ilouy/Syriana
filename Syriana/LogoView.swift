//
//  LogoView.swift
//  Syriana
//
//  Created by Fady Basem on 9/11/22.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack {
            Text("Syriana").font(Font.custom("KaushanScript-Regular", size: 64))
                .foregroundColor(Color("ThemeColor"))
            
            Text("center").font(Font.custom("KaushanScript-Regular", size: 25))
                .foregroundColor(Color("ThemeColor"))
                .offset(x: 0, y: -20)
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
