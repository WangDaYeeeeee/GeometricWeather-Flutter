import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    LocationPlugin.register(with: controller.binaryMessenger)
    
    GeneratedPluginRegistrant.register(with: self)
    
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60 * 60))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
