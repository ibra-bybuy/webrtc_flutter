import 'dart:io';

class CurrentPlatform {
  static bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
}
