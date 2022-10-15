//
//  CoursesView.swift
//  Syriana
//
//  Created by Fady Basem on 9/7/22.
//

import SwiftUI
import Combine
import Amplify

struct CoursesView: View {
    @State var coursesSubscriber: AnyCancellable!
    @State var courses: [String] = []
    @State var loading = true
    @Binding var instructor: String
    @Binding var selectedCourse: String
    @Binding var phase: Int
    @Binding var noInternet: Bool
    @Binding var noInternetAction: () -> ()
    @Binding var errorOccurred: Bool
    @Binding var errorMessage: String

    var body: some View {
        ZStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
                ForEach($courses, id: \.hashValue) { course in
                    GridItemView(image: .constant("BookIcon"), imageURL: .constant(nil), text: .constant("\(course.wrappedValue)"))
                        .onTapGesture {
                            selectedCourse = course.wrappedValue
                            phase += 1
                    }

                }
                
            }.onAppear {
                coursesSubscriber = getAllCourses()    
            }
            
            if loading {
                ProgressView()
            }
            
        }
    }
    
    func getAllCourses () -> AnyCancellable {
        let request = RESTRequest.init(path: "/courses", queryParameters: ["instructor": instructor])
        
        let sink = Amplify.API.get(request: request)
            .resultPublisher
            .sink {
                loading = false
                if case let .failure(apiError) = $0 {
                    //TODO: error handling
                    if apiError.errorDescription.localizedStandardContains("timed out"){
                        
                        noInternetAction = {
                            coursesSubscriber = getAllCourses()
                            noInternet = false
                        }
                        noInternet = true
                    } else {
                        errorOccurred = true
                        errorMessage = apiError.errorDescription + apiError.recoverySuggestion
                    }
                }
            }
            receiveValue: { data in
                loading = false
                print("received courses")
                
                do {
                    let decoder = JSONDecoder()
                    self.courses = try decoder.decode(CoursesJSONResponse.self, from: data).courses
                } catch {
                    
                }
            }
        return sink
    }
    
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(instructor: .constant(""), selectedCourse: .constant(""), phase: .constant(2), noInternet: .constant(false), noInternetAction: .constant {}, errorOccurred: .constant(false), errorMessage: .constant(""))
    }
}
