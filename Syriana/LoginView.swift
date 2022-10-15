//
//  LoginView.swift
//  Syriana
//
//  Created by Fady Basem on 9/11/22.
//

import SwiftUI
import Combine
import Amplify

struct LoginView: View {
    @State var username = ""
    @State var password = ""
    @State var loginSubscriber: AnyCancellable!
    @State var loggedIn = false
    
    @State var signupShown = false
    @State var forgotPasswordShown = false

    @State var errorOccurred = false
    @State var errorMessage = ""

    var body: some View {
        ZStack {
            Color("BackgroundColor")
            
            VStack {
                LogoView()
                    .foregroundColor(.clear)
                    .propotionalFrame(width: 1.0, height: 0.4)
                    .edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .foregroundColor(Color("ThemeColor"))
                    .propotionalFrame(width: 0.9, height: 0.6)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(20)
                
            }
            
            VStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .propotionalFrame(width: 1.0, height: 0.45)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    PhoneNumberTextField(text: $username)
                    PasswordSecureField(text: $password)
                    
                    Button(action: {
                        loginSubscriber = signIn()

                    }, label: {
                        Text("Login")
                            .foregroundColor(Color("ThemeColor"))
                            .padding()
                            .padding(.horizontal, 40)
                    })
                    .background(.white)
                    .cornerRadius(50)
                    .padding()
                    
                    HStack{
                        Button(action: {
                            signupShown = true
                        }, label: {
                            Text("Signup")
                                .foregroundColor(.white)
                        })
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            forgotPasswordShown = true
                        }, label: {
                            Text("Forgot Password?")
                                .foregroundColor(.white)
                        })
                        .padding()
                        
                    }
                    
                    Spacer()
                }.propotionalFrame(width: 0.9, height: 0.55)
                    .edgesIgnoringSafeArea(.all)

            }
            
            NavigationLink(destination: MainView(), isActive: $loggedIn) { EmptyView() }
            NavigationLink(destination: SignupView(signupShown: $signupShown), isActive: $signupShown) { EmptyView() }
            NavigationLink(destination: ForgotPasswordView(forgotPasswordShown: $forgotPasswordShown), isActive: $forgotPasswordShown) { EmptyView() }

        }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .alert(Text("An error occurred!"), isPresented: $errorOccurred) {
                Button() {
                    errorOccurred = false
                } label: {
                    Text("Ok")
                }
            } message: {
                Text(errorMessage)
            }
    }
    
    func updateNotificationToken(token: String) {
        
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.custom("notification_token"), value: token)) { result in
            do {
                //TODO: update notification badge
                let _ = try result.get()
                
            } catch {
                //TODO: Sign out and display alert
                print("Update attribute failed with error \(error)")
            }
        }
    }
    
    func signIn() -> AnyCancellable {
        
        Amplify.Auth.signIn(username: username, password: password)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    errorOccurred = true
                    errorMessage = authError.errorDescription + authError.recoverySuggestion
                }
            }
            receiveValue: { _ in
                print("Sign in succeeded")
                UserDefaults.standard.set(true, forKey: "loggedIn")

                updateNotificationToken(token: AppDelegate.notificationToken)
                loggedIn = true
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}


struct PhoneNumberTextField: View {
    @Binding private var text: String
    @FocusState private var isFocused: Bool

    init(text: Binding<String>) {
        self._text = text
    }
    
    var body: some View {
        ZStack {
            TextField("Phone Number", text: $text)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .multilineTextAlignment(.center).padding(20)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(30)
                .padding()
                .focused($isFocused)
                .onChange(of: isFocused) { newValue in
                    if !newValue {
                        if text == "+20" {
                            text = ""
                        }
                    } else {
                        if text == "" {
                            text = "+20"
                        }
                    }
                }.onChange(of: text) { newValue in
                    if text.count < 3 {
                        text = "+20"
                    }
                }

            
            HStack {
                Image(systemName: "phone")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
                    .padding()
                    .offset(x: 15, y: 0)
                
                Spacer()
            }
        }
    }
}

struct PasswordSecureField: View {
    @Binding private var text: String
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    var body: some View {
        ZStack {
            SecureInputView("Password", text: $text, prompt: Text("Password"))
                .multilineTextAlignment(.center)
                .padding(20)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(30)
                .padding()
                    
            
            HStack {
                Image(systemName: "lock")
                    .resizable()
                    .frame(width: 20, height: 25)
                    .foregroundColor(.black)
                    .padding()
                    .offset(x: 17, y: 0)
                
                Spacer()
            }
        }
    }
}
