import 'dart:io';

class CurrentPlatform {
  static bool get isDesktop {
    try {
      return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
    } catch (e) {
      return false;
    }
  }

  static bool get isMobile {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  static bool get isAndroid {
    try {
      return Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }
}
