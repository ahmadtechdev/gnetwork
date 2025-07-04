import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/8866278170';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/8866278170'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}