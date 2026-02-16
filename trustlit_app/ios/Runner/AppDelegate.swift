import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TestFlight detection method channel
    let controller = window?.rootViewController as! FlutterViewController
    let testFlightChannel = FlutterMethodChannel(
      name: "com.trustlt.app/testflight",
      binaryMessenger: controller.binaryMessenger
    )

    testFlightChannel.setMethodCallHandler { (call, result) in
      if call.method == "isTestFlight" {
        // Check if receipt URL contains "sandboxReceipt"
        // TestFlight builds use sandbox receipts, App Store builds do not
        if let receiptURL = Bundle.main.appStoreReceiptURL {
          let isTestFlight = receiptURL.lastPathComponent == "sandboxReceipt"
          result(isTestFlight)
        } else {
          result(false)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
