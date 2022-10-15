//
//  SettingsView.swift
//  Syriana
//
//  Created by Fady Basem on 9/7/22.
//

import SwiftUI
import Combine
import Amplify

struct SettingsView: View {
    @State var loggedOut = false
    @State var signOutSubscriber: AnyCancellable!
    @State var contactUsInfoShown = false
    @State var aboutUsShown = false

    var body: some View {
        ZStack{
            VStack {
                Button("Logout") {
                    signOutSubscriber = signOut()
                }
                
                Divider()
                
                Button("About Us") {
                    aboutUsShown = true
                }
                
                Divider()
                
                Button("Contact Us") {
                    withAnimation {
                        contactUsInfoShown.toggle()
                    }
                }
                
                if contactUsInfoShown {
                
                    HStack{
                        Button(action: {
                            let url = "https://wa.me/201025308170"
                                if let whatsappURL = URL(string: url) {
                                    UIApplication.shared.open(whatsappURL)
                                }
                        }) {
                               
                            Image("WhatsappIcon")
                               .resizable()
                               .frame(width: 50, height: 50)
                               .padding()
                        }
                        
                        
                        Button(action: {
                            let tel = "tel://+201025308170"
                            guard let url = URL(string: tel) else { return }
                            UIApplication.shared.open(url)
                           }) {
                               Image(systemName: "phone.fill")
                                   .resizable()
                                   .frame(width: 45, height: 45)
                                   .foregroundColor(Color("ThemeColor"))
                                   .padding()
                        }
                        
                        Spacer()
                        
                        Text("01025308170")
                            .padding()
                    }
                    
                }
                
                NavigationLink(destination: LoginView(), isActive: $loggedOut) { EmptyView() }
                
            }.blur(radius: aboutUsShown ? 30 : 0)
                .padding()
                .background(Color("GridBackgroundColor"))
                .cornerRadius(30)
                .padding()
            
            if aboutUsShown {
                Text("Syriana app is a collaboration project between QURIV Technologies L.L.C and Syriana Center.  Syriana is an educational app where students can find different courses with easy to use, well-organized interface and is a unique way to connect students and teachers. QURIV Technologies L.L.C is a company that specializes in creating apps, websites and programming projects. Syriana Center is an educational center located in 8 Ibn el Shogaa street, azarita, Alexandria.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(.white)
                    .cornerRadius(30)
                    .foregroundColor(.black)
                    .padding()
            }
        }.onTapGesture {
            aboutUsShown = false
        }
            
    }
    
    func signOut() -> AnyCancellable {
        Amplify.Auth.signOut()
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Sign out failed \(authError)")
                }
            }
            receiveValue: { _ in
                print("Sign out succeeded")
                UserDefaults.standard.set(false, forKey: "loggedIn")

                loggedOut = true
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
