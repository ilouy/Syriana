//
//  MyInstructorsView.swift
//  Syriana
//
//  Created by Fady Basem on 9/13/22.
//

import SwiftUI
import Combine
import Amplify

struct MyInstructorsView: View {
    @State var instructors: [String] = []
    @State var subjects: [[String]] = []
    @State var loading = true
    @Binding var selectedInstructor: String
    @Binding var phase: Int
    @Binding var subscribedSubjects: [String]
    @Binding var noInternet: Bool
    @Binding var noInternetAction: () -> ()
    @Binding var errorOccurred: Bool
    @Binding var errorMessage: String

    var body: some View {
        ZStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
                ForEach(Array($instructors.wrappedValue.enumerated()), id: \.element) { index, instructor in
                    GridItemView(image: .constant("FolderIcon"), imageURL: .constant(nil), text: .constant("Dr. \(instructor)"))
                        .onTapGesture {
                            selectedInstructor = instructor
                            subscribedSubjects = subjects[index]
                            phase += 1
                    }

                }
                
            }.onAppear {
                getMyCourses()
            }
            
            if loading {
                ProgressView()
            }
            
        }
    }
    
    func getMyCourses () {
        
        SyrianaApp.getAccessToken { accessToken in
            let request = RESTRequest(path: "/my-courses", headers: ["Authorization": accessToken])
            
            Amplify.API.get(request: request) { result in
                switch result {
                case .success(let data):
                    loading = false

                    do {
                        print("received my courses")
                        
                        let decoder = JSONDecoder()
                        let subscriptions = try decoder.decode(MyCoursesURLResponse.self, from: data).subscriptions
                        
                        for subscription in subscriptions {
                            instructors.append(subscription.instructor)
                            subjects.append(subscription.courses)
                        }
                    } catch {
                        
                    }
                case .failure(let apiError):
                    //TODO: error handling
                    loading = false

                    if apiError.errorDescription.localizedStandardContains("timed out"){
                        
                        noInternetAction = {
                            getMyCourses()
                            noInternet = false
                        }
                        noInternet = true
                    } else {
                        errorOccurred = true
                        errorMessage = apiError.errorDescription + apiError.recoverySuggestion
                    }
                }
            }
            
        } errorHandler: { error in
            //TODO: Error Handling
            print(error)
        }
    }
}

struct MyInstructorsView_Previews: PreviewProvider {
    static var previews: some View {
        MyInstructorsView(selectedInstructor: .constant(""), phase: .constant(0), subscribedSubjects: .constant([""]), noInternet: .constant(false), noInternetAction: .constant {}, errorOccurred: .constant(false), errorMessage: .constant(""))
    }
}
