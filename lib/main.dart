import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes/route.dart';
import 'theme_controller.dart';
import 'utils/my_strings.dart';

import 'theme/dark.dart';
import 'theme/light.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize SharedPreferences
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // Initialize ThemeController
  Get.put(ThemeController(sharedPreferences: sharedPreferences));

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (theme) {
      return GetMaterialApp(
        title: MyStrings.appName,
        initialRoute: RouteHelper.onboardScreen,
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