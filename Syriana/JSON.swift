//
//  JSON.swift
//  Syriana
//
//  Created by Fady Basem on 9/7/22.
//

import Foundation

struct InstructorsJSONResponse: Decodable {
    let instructors: [String]
}

struct CoursesJSONResponse: Decodable {
    let courses: [String]
}

struct VideosJSONResponse: Decodable {
    let videos: [VideoData]
}

struct VideoData: Decodable {
    var name: String
    var thumbnail: String
    var isPreview: Bool
}

struct NotificationsJSONResponse: Decodable {
    let notifications: [NotificationData]
}

struct NotificationData: Decodable {
    var body: String
    var datetime: String
}

struct VideoURLResponse: Decodable {
    let url: String
}

struct MyCoursesURLResponse: Decodable {
    var subscriptions: [MyCoursesData]
}

struct MyCoursesData: Decodable {
    var instructor: String
    var courses: [String]
}

struct RequestCodeResponse: Decodable {
    let exists: Bool
}
