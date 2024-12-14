import UIKit
import Flutter
import FirebaseCore
import GoogleMaps
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ")
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
           GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
     UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
