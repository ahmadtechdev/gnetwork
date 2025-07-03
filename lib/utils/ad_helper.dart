import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if(Platform.isAndroid){
      return 'ca-app-pub-5588063718705121/8866278170';
    }else if(Platform.isIOS){
      return '<IOS_BANNER_ID';
    }else {
      throw UnsupportedError('Un supported platform');
    }
  }
}