//
//  NotificationItemView.swift
//  Syriana
//
//  Created by Fady Basem on 9/7/22.
//

import SwiftUI

struct NotificationItemView: View {
    @Binding var notificationBody: String
    @Binding var notificationDatetime: String
    
    var body: some View {
        VStack{
            HStack {
                Image("NotificationIcon")
                Text(notificationBody)
                Spacer()
            }
            
            HStack {
                Spacer()
                Text(getDateTimeFormat(notificationDatetime: notificationDatetime))
                    .foregroundColor(.indigo)
                    .bold()
            }
                        
        }.padding()
            .background(Color("GridBackgroundColor"))
    }
    
    func getDateTimeFormat (notificationDatetime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
        let dateTime = dateFormatter.date(from: notificationDatetime + " +0000")!

        if dateTime > Date.now.addingTimeInterval(-60) {
            return "Just Now"
        } else if dateTime < Date.now.addingTimeInterval(-60) && dateTime > Date.now.addingTimeInterval(-3600) {
            
            let difference = Calendar.current.dateComponents([.minute], from: dateTime, to: Date.now)
            return difference.minute!.description + (difference.minute! == 1 ? " minute ago" : " minutes ago")
        } else if dateTime < Date.now.addingTimeInterval(-3600) && dateTime > Date.now.addingTimeInterval(-86400) {
            
            let difference = Calendar.current.dateComponents([.hour], from: dateTime, to: Date.now)
            return difference.hour!.description + (difference.hour! == 1 ? " hour ago" : " hours ago")
        } else {
            let newDateFormatter = DateFormatter()
            newDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            newDateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

            return newDateFormatter.string(from: dateTime)
        }

    }
}

struct NotificationItemView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationItemView(notificationBody: .constant("Notification Body Notification Text"), notificationDatetime: .constant("23/03/2022 20:18"))
    }
}
