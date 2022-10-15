//
//  SyrianaApp.swift
//  Syriana
//
//  Created by Fady Basem on 07/08/2022.
//

import SwiftUI
import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSPluginsCore
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@main
struct SyrianaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if (UserDefaults.standard.object(forKey: "loggedIn") as? Bool ?? false) {
                    MainView()
                } else {
                    LoginView()
                }
            }.navigationViewStyle(StackNavigationViewStyle())
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                    
                    print("screenshot")
                    AppDelegate.screenRecordingInProgress = true
                }.onReceive(NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)) { value in

                    print("screen recording \(value)")
                    AppDelegate.screenRecordingInProgress = true
                }
        }
    }
    
    static func getAccessToken (completionHandler: @escaping (String) -> (), errorHandler: @escaping (AuthError) -> ()) {
        Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                do {
                    if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                        let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                        completionHandler(tokens.accessToken)
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print("Fetch session failed with error \(error)")
                errorHandler(error)
            }
        }
    }

    
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    static var notificationToken = "token"
    static var isBlocked = false
    static var screenRecordingInProgress = false
    
    func checkIfBlocked () {
        if (UserDefaults.standard.object(forKey: "loggedIn") as? Bool ?? false) {
            Amplify.Auth.fetchUserAttributes() { result in
                switch result {
                case .success(_):
                    //print("User attributes - \(attributes)")
                    break
                case .failure(let error):
                    if error.errorDescription.localizedCaseInsensitiveContains("disabled") {
                        AppDelegate.isBlocked = true
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            
            FirebaseApp.configure()
            
            checkIfBlocked()
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        
        registerForPushNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                AppDelegate.notificationToken  = token
                
                if (UserDefaults.standard.object(forKey: "loggedIn") as? Bool ?? false) {
                    Amplify.Auth.update(userAttribute: AuthUserAttribute(.custom("notification_token"), value: token)) { _ in
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register for remote notifications with error: \(error)")

    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")

            guard granted else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

extension View {
    func propotionalFrame(width: CGFloat, height: CGFloat, isSquared: Bool = false, alignment: Alignment = .center) -> some View {
        
        let finalWidth = UIScreen.main.bounds.width * width
        let finalHeight = isSquared ? finalWidth : UIScreen.main.bounds.height * height
        return frame(width: finalWidth, height: finalHeight)
    }
    
}
