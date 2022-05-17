import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ForegroundService {
  final String title;
  final String body;
  const ForegroundService({this.title = "", this.body = ""});

  bool get isAvailable => WebRTC.platformIsAndroid;
  bool get isInBackground => FlutterBackground.isBackgroundExecutionEnabled;

  Future<bool> start() async {
    if (!isAvailable) {
      return false;
    }

    await FlutterBackground.initialize(androidConfig: config);
    return await FlutterBackground.enableBackgroundExecution();
  }

  Future<bool> stop() async {
    if (isInBackground) {
      return await FlutterBackground.disableBackgroundExecution();
    }
    return false;
  }

  FlutterBackgroundAndroidConfig get config => FlutterBackgroundAndroidConfig(
        notificationTitle: title,
        notificationText: body,
        notificationImportance: AndroidNotificationImportance.Default,
      );
}
