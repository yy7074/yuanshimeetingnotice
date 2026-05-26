import Flutter
import EventKit
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let calendarEventStore = EKEventStore()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let didFinish = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    registerCalendarPermissionChannel()
    return didFinish
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func registerCalendarPermissionChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "apscvir/calendar_permission",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "requestCalendarAccess" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.requestCalendarAccess(result)
    }
  }

  private func requestCalendarAccess(_ result: @escaping FlutterResult) {
    let status = EKEventStore.authorizationStatus(for: .event)

    if #available(iOS 17.0, *) {
      switch status {
      case .fullAccess, .writeOnly, .authorized:
        result(true)
      case .notDetermined:
        calendarEventStore.requestFullAccessToEvents { granted, _ in
          DispatchQueue.main.async {
            result(granted)
          }
        }
      case .denied, .restricted:
        result(false)
      @unknown default:
        result(false)
      }
    } else {
      switch status {
      case .authorized:
        result(true)
      case .notDetermined:
        calendarEventStore.requestAccess(to: .event) { granted, _ in
          DispatchQueue.main.async {
            result(granted)
          }
        }
      case .denied, .restricted:
        result(false)
      @unknown default:
        result(false)
      }
    }
  }
}
