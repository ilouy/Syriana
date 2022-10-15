//
//  ForgotPasswordView.swift
//  Syriana
//
//  Created by Fady Basem on 9/17/22.
//

import SwiftUI
import Amplify

struct ForgotPasswordView: View {
    @State var phase = 1
    
    @State var phoneNumber = ""
    @State var confirmationCode = ""

    @State var password = ""
    @State var confirmPassword = ""
    
    @FocusState private var phoneNumberIsFocused: Bool
    @Binding var forgotPasswordShown: Bool

    @State var errorOccurred = false
    @State var errorMessage = ""

    var body: some View {
        ZStack {
            Color("BackgroundColor")
            
            VStack {
                LogoView()
                    .foregroundColor(.clear)
                    .propotionalFrame(width: 1.0, height: 0.3)
                    .edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .foregroundColor(Color("ThemeColor"))
                    .propotionalFrame(width: 0.9, height: 0.7)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(20)
                
            }
            
            if phase == 1 {
                
                VStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .propotionalFrame(width: 1.0, height: 0.3)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Please enter your phone number:").foregroundColor(.white)
                            .padding()
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .foregroundColor(.black)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .multilineTextAlignment(.center)
                            .padding(25)
                            .background(.white)
                            .cornerRadius(50)
                            .padding()
                            .focused($phoneNumberIsFocused)
                            .onChange(of: phoneNumberIsFocused) { newValue in
                                if !newValue {
                                    if phoneNumber == "+20" {
                                        phoneNumber = ""
                                    }
                                } else {
                                    if phoneNumber == "" {
                                        phoneNumber = "+20"
                                    }
                                }
                            }.onChange(of: phoneNumber) { newValue in
                                if phoneNumber.count < 3 {
                                    phoneNumber = "+20"
                                }
                            }
                        
                        Button(action: {
                            if !(phoneNumber[2..<4] == "01" && phoneNumber.count == 13) {
                                errorOccurred = true
                                errorMessage = "Incorrect phone number"
                                return
                            }
                            
                            Amplify.Auth.resetPassword(for: phoneNumber) { result in
                                phase = 2
                            }
                            
                        }, label: {
                            Text("Continue")
                                .foregroundColor(Color("ThemeColor"))
                                .bold()
                                .padding()
                                .padding(.horizontal, 30)
                        })
                        .background(.white)
                        .cornerRadius(50)
                        .padding()
                        
                        
                        Spacer()
                    }.propotionalFrame(width: 0.9, height: 0.55)
                        .edgesIgnoringSafeArea(.all)
                    
                }
                
            }
            
            if phase == 2 {
                
                VStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .propotionalFrame(width: 1.0, height: 0.3)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Please enter the confirmation code sent to your phone number:")
                            .foregroundColor(.white)
                            .padding()
                        
                        TextField("Confirmation Code", text: $confirmationCode)
                            .foregroundColor(.black)
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            .multilineTextAlignment(.center)
                            .padding(25)
                            .background(.white)
                            .cornerRadius(50)
                            .padding()
                        
                        Button(action: {
                            if confirmationCode.count != 6 {
                                errorOccurred = true
                                errorMessage = "Incorrect confirmation code."
                                return
                            }
                            
                            phase = 3
                            
                        }, label: {
                            Text("Continue")
                                .foregroundColor(Color("ThemeColor"))
                                .bold()
                                .padding()
                                .padding(.horizontal, 30)
                        })
                        .background(.white)
                        .cornerRadius(50)
                        .padding()
                        
                        
                        Spacer()
                    }.propotionalFrame(width: 0.9, height: 0.55)
                        .edgesIgnoringSafeArea(.all)
                    
                }
            }
            
            if phase == 3 {
                
                VStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .propotionalFrame(width: 1.0, height: 0.3)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        SecureInputView("Password", text: $password, prompt: Text("Password"))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(25)
                            .background(.white)
                            .cornerRadius(50)
                            .padding()
                        
                        SecureInputView("Confirm Password", text: $confirmPassword, prompt: Text("Confirm Password"))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(25)
                            .background(.white)
                            .cornerRadius(50)
                            .padding()
                        
                        Button(action: {
                            if password != confirmPassword {
                                errorOccurred = true
                                errorMessage = "Passwords do not match."
                                return
                            }
                            
                            if !password.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,20}$") {
                                errorOccurred = true
                                errorMessage = "Passwords should contain:\n•At least 8 characters.\n•At least 1 uppercase letter.\n•At least 1 lowercase letter.\n•At least 1 number."
                                return
                            }
                            
                            Amplify.Auth.confirmResetPassword(for: phoneNumber, with: password, confirmationCode: confirmationCode) { result in
                                switch result {
                                case .success:
                                    forgotPasswordShown = false
                                case .failure(let error):
                                    errorOccurred = true
                                    errorMessage = error.errorDescription + error.recoverySuggestion
                                }
                            }
                            
                        }, label: {
                            Text("Finish")
                                .foregroundColor(Color("ThemeColor"))
                                .bold()
                                .padding()
                                .padding(.horizontal, 30)
                        })
                        .background(.white)
                        .cornerRadius(50)
                        .padding()
                        
                        
                        Spacer()
                    }.propotionalFrame(width: 0.9, height: 0.55)
                        .edgesIgnoringSafeArea(.all)
                    
                }
                
            }

        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor"))
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if phase == 1 {
                            forgotPasswordShown = false
                        } else {
                            phase -= 1
                        }
                    } label: {
                        Label("Back", systemImage: "chevron.backward")
                            .labelStyle(HorizontalLabelStyle())
                    }
                }
            })
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
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(forgotPasswordShown: .constant(true))
    }
}
