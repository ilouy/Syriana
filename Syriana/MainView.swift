//
//  ContentView.swift
//  Syriana
//
//  Created by Fady Basem on 07/08/2022.
//

import SwiftUI

struct MainView: View {
    @State var newNotificationsAvailable = false
    @State var navigationBarTitle = "All Courses"
    @State var tabSelected = 1
    @State var backButtonVisible = false
    @State var backButtonAction: () -> () = {}
    @State var noInternetConnection = false
    @State var noInternetTryAgainAction: () -> () = {}
    @State var errorAlertShowing = false
    @State var errorAlertMessage = ""

    var body: some View {
        if AppDelegate.isBlocked {
            UserBlockedView()
        } else {
            if noInternetConnection {
                NoInternetConnectionView(tryAgainAction: $noInternetTryAgainAction)
            } else {
                TabView(selection: $tabSelected) {
                    AllCoursesView(backButtonVisible: $backButtonVisible, backButtonAction: $backButtonAction, navigationBarTitle: $navigationBarTitle, noInternet: $noInternetConnection, noInternetAction: $noInternetTryAgainAction, errorOccurred: $errorAlertShowing, errorMessage: $errorAlertMessage)
                        .padding()
                        .tabItem {
                            Label("All Courses", systemImage: "house")
                        }.background(Color("BackgroundColor"))
                        .tag(1)
                    
                    MyCoursesView(backButtonVisible: $backButtonVisible, backButtonAction: $backButtonAction, navigationBarTitle: $navigationBarTitle, noInternet: $noInternetConnection, noInternetAction: $noInternetTryAgainAction, errorOccurred: $errorAlertShowing, errorMessage: $errorAlertMessage)
                        .padding()
                        .tabItem {
                            Label("My Courses", systemImage: "person")
                        }.background(Color("BackgroundColor"))
                        .tag(2)
                    
                    NotificationsView(noInternet: $noInternetConnection, noInternetAction: $noInternetTryAgainAction, errorOccurred: $errorAlertShowing, errorMessage: $errorAlertMessage)
                        .padding()
                        .tabItem {
                            Label("Notifications", systemImage: "bell")
                        }.badge(newNotificationsAvailable ? "" : nil)
                        .background(Color("BackgroundColor"))
                        .tag(3)
                    
                    SettingsView().tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("BackgroundColor"))
                        .tag(4)
                                
                }.navigationBarTitle(navigationBarTitle)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            if backButtonVisible {
                                Button {
                                    backButtonAction()
                                } label: {
                                    Label("Back", systemImage: "chevron.backward")
                                        .labelStyle(HorizontalLabelStyle())
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    })
                    .onAppear {
                        //TODO: check for new notifications
                        
                    }.onChange(of: tabSelected) { newValue in
                        switch newValue {
                        case 1:
                            navigationBarTitle = "All Courses"
                        case 2:
                             navigationBarTitle = "My Courses"
                        case 3:
                            navigationBarTitle = "Notifications"
                        case 4:
                            navigationBarTitle = "Settings"
                        default:
                            break
                        }
                    }.alert(Text("An error occurred!"), isPresented: $errorAlertShowing) {
                        Button() {
                            errorAlertShowing = false
                        } label: {
                            Text("Ok")
                        }
                    } message: {
                        Text(errorAlertMessage)
                    }

            }
            
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct HorizontalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
