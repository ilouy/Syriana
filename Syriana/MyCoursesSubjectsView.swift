//
//  MyCoursesSubjectsView.swift
//  Syriana
//
//  Created by Fady Basem on 9/13/22.
//

import SwiftUI

struct MyCoursesSubjectsView: View {
    @Binding var subjects: [String]
    @Binding var phase: Int
    @Binding var instructor: String
    @Binding var selectedCourse: String

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
            ForEach($subjects, id: \.hashValue) { course in
                GridItemView(image: .constant("BookIcon"), imageURL: .constant(nil), text: .constant("\(course.wrappedValue)"))
                    .onTapGesture {
                        selectedCourse = course.wrappedValue
                        phase += 1
                }

            }
            
        }
    }
}

struct MyCoursesSubjectsView_Previews: PreviewProvider {
    static var previews: some View {
        MyCoursesSubjectsView(subjects: .constant([""]), phase: .constant(0), instructor: .constant(""), selectedCourse: .constant(""))
    }
}
