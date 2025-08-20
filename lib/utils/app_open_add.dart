import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;
  final String _adUnitId;

  AppOpenAdManager({required String adUnitId}) : _adUnitId = adUnitId;

  // Function to load the ad
  void loadAd() {
    AppOpenAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            print('AppOpenAd loaded successfully');
          }
          _appOpenAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print('AppOpenAd failed to load: $error');
          }
          _isAdLoaded = false;
        },
      ),
    );
  }

  // Function to show the ad if it is ready and Firebase allows it
  void showAdIfAvailable() {
    if (!_isAdLoaded || _appOpenAd == null) {
      if (kDebugMode) {
        print('Ad not ready yet. Loading a new one.');
      }
      loadAd(); // Load a new one for the next time
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isAdLoaded = false; // Reset the flag
        if (kDebugMode) {
          print('AppOpenAd showed full screen content.');
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        if (kDebugMode) {
          print('AppOpenAd dismissed.');
        }
        ad.dispose();
        _appOpenAd = null;
        loadAd(); // Preload the next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          print('AppOpenAd failed to show: $error');
        }
        ad.dispose();
        _appOpenAd = null;
        loadAd(); // Preload the next ad
      },
    );

    _appOpenAd!.show();
  }

  // Function to dispose of the ad
  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isAdLoaded = false;
  }

  // Getter to check if ad is loaded
  bool get isAdLoaded => _isAdLoaded;
}