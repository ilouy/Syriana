//
//  AllCoursesView.swift
//  Syriana
//
//  Created by Fady Basem on 9/5/22.
//

import SwiftUI

struct AllCoursesView: View {
    @State var phase = 0
    @State var selectedInstructor = ""
    @State var selectedCourse = ""
    @Binding var backButtonVisible: Bool
    @Binding var backButtonAction: () -> ()
    @Binding var navigationBarTitle: String
    @Binding var noInternet: Bool
    @Binding var noInternetAction: () -> ()
    @Binding var errorOccurred: Bool
    @Binding var errorMessage: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color("GridBackgroundColor"))
            ScrollView {
                if phase == 0 {
                    InstructorsView(selectedInstructor: $selectedInstructor, phase: $phase, noInternet: $noInternet, noInternetAction: $noInternetAction, errorOccurred: $errorOccurred, errorMessage: $errorMessage).padding(15)
                } else if phase == 1 {
                    CoursesView(instructor: $selectedInstructor, selectedCourse: $selectedCourse, phase: $phase, noInternet: $noInternet, noInternetAction: $noInternetAction, errorOccurred: $errorOccurred, errorMessage: $errorMessage).padding(15)
                } else if phase == 2 {
                    VideosView(instructor: $selectedInstructor, course: $selectedCourse, type: .constant(.previewShown), noInternet: $noInternet, noInternetAction: $noInternetAction, errorOccurred: $errorOccurred, errorMessage: $errorMessage).padding(15)
                }
                    
            }
        }.padding()
            .background(Color("BackgroundColor"))
            .navigationBarBackButtonHidden(true)
            .onChange(of: phase) { newPhase in
                backButtonVisible = phase != 0
                
                switch phase {
                    
                case 0:
                    navigationBarTitle = "All Courses"
                case 1:
                    navigationBarTitle = "Dr. " + selectedInstructor
                case 2:
                    navigationBarTitle = selectedCourse
                default:
                    break
                    
                }
            }.onAppear {
                backButtonAction = {
                    if phase != 0 {
                        phase -= 1
                    }
                    
                }
            }
    }
}

struct AllCoursesView_Previews: PreviewProvider {
    static var previews: some View {
        AllCoursesView(backButtonVisible: .constant(false), backButtonAction: .constant({}), navigationBarTitle: .constant("All Courses"), noInternet: .constant(false), noInternetAction: .constant {}, errorOccurred: .constant(false), errorMessage: .constant(""))
    }
}
