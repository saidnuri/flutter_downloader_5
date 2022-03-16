import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2567472206716852/7517473309';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
