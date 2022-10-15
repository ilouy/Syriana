//
//  NotificationsView.swift
//  Syriana
//
//  Created by Fady Basem on 9/7/22.
//

import SwiftUI
import Amplify

struct NotificationsView: View {
    @State var notifications: [NotificationData] = []
    @Binding var noInternet: Bool
    @Binding var noInternetAction: () -> ()
    @Binding var errorOccurred: Bool
    @Binding var errorMessage: String

    var body: some View {
        List {
            ForEach($notifications, id: \.wrappedValue.body.hashValue) { notification in
                NotificationItemView(notificationBody: notification.body, notificationDatetime: notification.datetime)
                    .listRowInsets(EdgeInsets())

            }
            
        }.listStyle(PlainListStyle())
            .background(Color("GridBackgroundColor"))
            .cornerRadius(30)
            .padding()
            .onAppear {
                getNotifications()
            }
    }
    
    func getNotifications () {
        
        SyrianaApp.getAccessToken { accessToken in
            let request = RESTRequest(path: "/notifications", headers: ["Authorization": accessToken])
            
            Amplify.API.get(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        print("received notifications")
                        
                        let decoder = JSONDecoder()
                        self.notifications = try decoder.decode(NotificationsJSONResponse.self, from: data).notifications
                        
                    } catch {
                        
                    }
                case .failure(let apiError):
                    //TODO: error handling
                    print("Failed", apiError)
                    
                    if apiError.errorDescription.localizedStandardContains("timed out"){
                        
                        noInternetAction = {
                            getNotifications()
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

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(noInternet: .constant(false), noInternetAction: .constant {}, errorOccurred: .constant(false), errorMessage: .constant(""))
    }
}
