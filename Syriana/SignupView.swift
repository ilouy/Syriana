//
//  SignupView.swift
//  Syriana
//
//  Created by Fady Basem on 9/15/22.
//

import SwiftUI
import Amplify

struct SignupView: View {
    @State var name = ""
    @State var email = ""
    @State var phoneNumber = ""
    @State var year = ""
    @State var gender = ""
    
    @State var maleBackgroundColor = Color.clear
    @State var femaleBackgroundColor = Color.clear
    
    @State var requestCode = ""
    
    @State var password = ""
    @State var confirmPassword = ""
    
    @State var phase = 1
    
    @FocusState private var phoneNumberIsFocused: Bool
    @Binding var signupShown: Bool

    @State var errorOccurred = false
    @State var errorMessage = ""

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
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
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
            }
            
            if phase == 1 {
                
                VStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .propotionalFrame(width: 1.0, height: 0.3)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Please enter your request code:").foregroundColor(.white)
                            .padding()
                        
                        TextField("Request Code", text: $requestCode)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(25)
                            .background(.white)
                            .cornerRadius(50)
                            .padding()
                        
                        Label("This request code can be found on your card.", systemImage: "questionmark.circle.fill")
                            .foregroundColor(.white)
                            .padding()
                        
                        Button(action: {
                            checkRequestCode()
                            
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
                        TextField("Full Name", text: $name)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(25)
                            .background(.white)
                            .cornerRadius(50)
                            .padding()
                        
                        TextField("Email", text: $email)
                            .foregroundColor(.black)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .multilineTextAlignment(.center)
                            .padding(25)
                            .background(.white)
                            .cornerRadius(50)
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
                        
                        HStack{
                            TextField("Year", text: $year)
                                .foregroundColor(.black)
                                .keyboardType(.numberPad)
                                .textContentType(.dateTime)
                                .multilineTextAlignment(.center)
                                .padding(25)
                                .background(.white)
                                .cornerRadius(50)
                                .padding()
                            
                            Spacer()
                            
                            HStack{
                                Image("MaleIcon")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .background(maleBackgroundColor)
                                    .onTapGesture {
                                        maleBackgroundColor = .gray
                                        femaleBackgroundColor = .clear
                                        
                                        gender = "male"
                                    }
                                
                                Divider()
                                
                                Image("FemaleIcon")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .background(femaleBackgroundColor)
                                    .onTapGesture {
                                        maleBackgroundColor = .clear
                                        femaleBackgroundColor = .gray
                                        
                                        gender = "female"
                                    }
                                
                            }.frame(width: 150, height: 75)
                                .background(.white)
                                .cornerRadius(20)
                                .padding()
                        }
                        
                        Button(action: {
                            if name.isEmpty {
                                errorOccurred = true
                                errorMessage = "Name can't be empty."
                                return
                            }
                            
                            if !(phoneNumber[2..<4] == "01" && phoneNumber.count == 13) {
                                errorOccurred = true
                                errorMessage = "Incorrect phone number entered."

                                return
                            }
                            
                            if !email.matches(
                                "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$") {
                                
                                errorOccurred = true
                                errorMessage = "Incorrect email address entered."
                                return
                                
                            }
                            
                            if year.isEmpty {
                                errorOccurred = true
                                errorMessage = "Year can't be empty."
                                return
                            }
                            
                            if gender.isEmpty {
                                errorOccurred = true
                                errorMessage = "Please select your gender."
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
                            
                            let attributes = [
                                AuthUserAttribute(.name, value: name),
                                AuthUserAttribute(.gender, value: gender),
                                AuthUserAttribute(.phoneNumber, value: phoneNumber),
                                AuthUserAttribute(.email, value: email),
                                AuthUserAttribute(.custom("notification_token"), value: requestCode),
                                AuthUserAttribute(.custom("year"), value: year)
                            ]
                            
                            let signupOptions = AuthSignUpRequest.Options(userAttributes: attributes)
                            
                            Amplify.Auth.signUp(username: phoneNumber, password: password, options: signupOptions) { result in
                                    switch result {
                                    case .success(_):
                                        signupShown = false
                                    case .failure(let error):
                                        //TODO: Show alert
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
                            signupShown = false
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
    
    func checkRequestCode () {
        let request = RESTRequest(path: "/request-codes", queryParameters: ["requestCode": requestCode])
        
        Amplify.API.get(request: request) { result in
            switch result {
            case .success(let data):
                do {                    
                    let decoder = JSONDecoder()
                    let exists = try decoder.decode(RequestCodeResponse.self, from: data).exists
                    
                    if exists {
                        phase = 2
                    } else {
                        errorOccurred = true
                        errorMessage = "Incorrect request code."
                    }
                    
                } catch {
                    
                }
            case .failure(let apiError):
                //TODO: error handling
                errorOccurred = true
                errorMessage = apiError.errorDescription + apiError.recoverySuggestion
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(signupShown: .constant(true))
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
