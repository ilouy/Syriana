//
//  InstructorsView.swift
//  Syriana
//
//  Created by Fady Basem on 9/7/22.
//

import SwiftUI
import Combine
import Amplify

struct InstructorsView: View {
    @State var instructorsSubscriber: AnyCancellable!
    @State var instructors: [String] = []
    @State var loading = true
    @Binding var selectedInstructor: String
    @Binding var phase: Int
    @Binding var noInternet: Bool
    @Binding var noInternetAction: () -> ()
    @Binding var errorOccurred: Bool
    @Binding var errorMessage: String

    var body: some View {
        ZStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
                ForEach($instructors, id: \.hashValue) { instructor in
                    GridItemView(image: .constant("FolderIcon"), imageURL: .constant(nil), text: .constant("Dr. \(instructor.wrappedValue)"))
                        .onTapGesture {
                            selectedInstructor = instructor.wrappedValue
                            phase += 1
                    }

                }
                
            }.onAppear {
                instructorsSubscriber = getInstructors()
            }
            
            if loading {
                ProgressView()
            }
        }
    }
    
    func getInstructors () -> AnyCancellable {
        let request = RESTRequest(path: "/instructors")
        
        let sink = Amplify.API.get(request: request)
            .resultPublisher
            .sink {
                loading = false
                if case let .failure(apiError) = $0 {
                    if apiError.errorDescription.localizedStandardContains("timed out"){
                        print("timed out")
                        
                        noInternetAction = {
                            instructorsSubscriber = getInstructors()
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
                print("received instructors")
                loading = false
                
                do {
                    let decoder = JSONDecoder()
                    self.instructors = try decoder.decode(InstructorsJSONResponse.self, from: data).instructors
                } catch {
                    print(error)
                }
            }
        return sink
    }

}

struct InstructorsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructorsView(selectedInstructor: .constant(""), phase: .constant(1), noInternet: .constant(false), noInternetAction: .constant {}, errorOccurred: .constant(false), errorMessage: .constant(""))
    }
}
