//
//  GridItemView.swift
//  Syriana
//
//  Created by Fady Basem on 9/5/22.
//

import SwiftUI

struct GridItemView: View {
    @Binding var image: String!
    @Binding var imageURL: String!
    @Binding var text: String
    
    var body: some View {
        VStack {
            if imageURL == nil {
                Image(image)
                    .frame(width: 100, height: 100, alignment: .center)
            } else {
                AsyncImage(url: URL(string: imageURL)) { image in
                    
                    image.resizable().scaledToFill().frame(width: 80, height: 80, alignment: .center)
                } placeholder: {
                    Color.gray.frame(width: 100, height: 100)
                }

            }
            
            Text(text)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.center)
        }.padding(25.0)
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        GridItemView(image: .constant(nil), imageURL: .constant("https://amplify-syriana-dev-10930-deployment.s3.amazonaws.com/Data/Instructors/Mazen+Shaalan/Videos/Geology/Presentation.jpg"), text: .constant("Mazen Shaalan"))
    }
}
