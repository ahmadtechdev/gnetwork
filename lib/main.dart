import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcoin/screens/homescreen/home_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service/local_stroge.dart';
import 'routes/route.dart';
import 'theme_controller.dart';
import 'utils/my_strings.dart';

import 'theme/dark.dart';
import 'theme/light.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
// MobileAds.instance.initialize();
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize GetStorage
  await GetStorage.init();


  // Initialize SharedPreferences
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // Initialize ThemeController
  Get.put(ThemeController(sharedPreferences: sharedPreferences));

  // Check if user has a valid token
  final hasValidToken = LocalStorage.getToken() != null;

  Get.lazyPut<HomeController>(() => HomeController(), fenix: true);


  // --- THIS IS THE CRITICAL PART FOR TEST DEVICES ---
  // Only set test devices when in debug mode
  if (kDebugMode) {
    // Get your actual device ID from the logcat/Xcode console
    // Example: 'YOUR_COPIED_ANDROID_DEVICE_ID_HERE'
    // You might have separate IDs for Android and iOS devices
    final List<String> testDeviceIds = [
      // Add your specific Android test device ID here:
      // 'YOUR_ANDROID_TEST_DEVICE_ID_FROM_LOGCAT',
      // Add your specific iOS test device ID here:
      // 'YOUR_IOS_TEST_DEVICE_ID_FROM_XCODE_CONSOLE',
    ];

    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: testDeviceIds,
        // You can also set tagForChildDirectedTreatment here if needed
        // tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        // maxAdContentRating: MaxAdContentRating.g,
      ),
    );
    print('AdMob: Test devices configured for debug mode.');
  }
  // --- END CRITICAL PART ---

  MobileAds.instance.initialize();

  runApp(MainApp(initialRoute: hasValidToken ? RouteHelper.homeScreen : RouteHelper.onboardScreen));
}

class MainApp extends StatelessWidget {

  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (theme) {
      return GetMaterialApp(
        title: MyStrings.appName,
        initialRoute: initialRoute,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        getPages: RouteHelper.routes,
        navigatorKey: Get.key,
        theme: theme.darkTheme ? dark : light,
        debugShowCheckedModeBanner: false,
        // Set system UI overlay style
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: theme.darkTheme
                ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
            )
                : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
            ),
            child: child!,
          );
        },
      );
    });
  }
}