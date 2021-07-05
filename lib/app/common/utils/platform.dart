import 'dart:io';

class GeoPlatform {

  static final bool isMaterialStyle =
      Platform.isAndroid
          || Platform.isFuchsia
          ||Platform.isLinux
          ||Platform.isWindows;

  static final bool isCupertinoStyle =
      Platform.isIOS
          || Platform.isMacOS;
}