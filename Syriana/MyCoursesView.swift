//
//  MyCoursesView.swift
//  Syriana
//
//  Created by Fady Basem on 9/5/22.
//

import SwiftUI

struct MyCoursesView: View {
    @State var phase = 0
    @State var selectedInstructor = ""
    @State var subscribedSubjects = [String]()
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
                    MyInstructorsView(selectedInstructor: $selectedInstructor, phase: $phase, subscribedSubjects: $subscribedSubjects, noInternet: $noInternet, noInternetAction: $noInternetAction, errorOccurred: $errorOccurred, errorMessage: $errorMessage).padding(15)
                } else if phase == 1 {
                    MyCoursesSubjectsView(subjects: $subscribedSubjects, phase: $phase, instructor: $selectedInstructor, selectedCourse: $selectedCourse).padding(15)
                } else if phase == 2 {
                    VideosView(instructor: $selectedInstructor, course: $selectedCourse, type: .constant(.previewNotShown), noInternet: $noInternet, noInternetAction: $noInternetAction, errorOccurred: $errorOccurred, errorMessage: $errorMessage).padding(15)
                }
                    
            }
        }.padding()
            .background(Color("BackgroundColor"))
            .navigationBarBackButtonHidden(true)
            .onChange(of: phase) { newPhase in
                backButtonVisible = phase != 0
                
                switch phase {
                    
                case 0:
                    navigationBarTitle = "My Courses"
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

struct MyCoursesView_Previews: PreviewProvider {
    static var previews: some View {
        MyCoursesView(backButtonVisible: .constant(false), backButtonAction: .constant({}), navigationBarTitle: .constant(""), noInternet: .constant(false), noInternetAction: .constant {}, errorOccurred: .constant(false), errorMessage: .constant(""))
    }
}
