import 'dart:io';

class DeviceInfo {
  static String get label {
    return Platform.operatingSystem + '(' + Platform.localHostname + ")";
  }

  static String get userAgent {
    return 'flutter-webrtc/' + Platform.operatingSystem + '-plugin 0.0.1';
  }
}
