import 'dart:io';

class AdHelper {
  // Original Banner Ad
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/8866278170';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/8866278170'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Dashboard Bottom Ad
  static String get dashboardBottomAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/9672743757';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/9672743757'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Game Screen Ad
  static String get gameScreenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/8359662080';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/8359662080'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Mining Game Screen Ad
  static String get miningGameScreenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/1992165480';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/1992165480'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Profile Screen Ads (Top and Bottom)
  static String get profileScreenTopAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/9679083813';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/9679083813'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get profileScreenBottomAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/8366002145';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/8366002145'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Wallet Screen Ads (Top and Bottom)
  static String get walletScreenTopAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/7052920473';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/7052920473'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get walletScreenBottomAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/5739838804';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/5739838804'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Withdraw Screen Ad
  static String get withdrawScreenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/4426757139';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/4426757139'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // FAQ Screen Ad
  static String get faqScreenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/4492569260';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/4492569260'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Mining Screen Ad
  static String get miningScreenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/1800593795';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/1800593795'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String get miningScreenRewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5588063718705121/6943472781';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5588063718705121/6943472781'; // Replace with actual iOS ID if different
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}