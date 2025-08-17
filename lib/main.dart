import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcoin/screens/homescreen/home_controller.dart';
import 'package:gcoin/screens/maintenance/controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'api_service/api_service.dart';
import 'api_service/local_stroge.dart';
import 'routes/route.dart';
import 'theme_controller.dart';
import 'screens/maintenance/maintenance_screen.dart';
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

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize SharedPreferences
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // Initialize ThemeController
  Get.put(ThemeController(sharedPreferences: sharedPreferences));

  // Initialize HomeController
  Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  // Add this before runApp() in main()
  Get.put(MaintenanceController());

  // Configure AdMob for test devices in debug mode
  if (kDebugMode) {
    final List<String> testDeviceIds = [
      // Add your specific test device IDs here
    ];

    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: testDeviceIds,
      ),
    );
    print('AdMob: Test devices configured for debug mode.');
  }

  // Initialize MobileAds
  MobileAds.instance.initialize();

  // Check internet connectivity first
  final connectivityResult = await Connectivity().checkConnectivity();
  final bool hasInternet = connectivityResult != ConnectivityResult.none;

  String initialRoute;

  if (!hasInternet) {
    // If no internet, proceed with normal app flow
    final hasValidToken = LocalStorage.getToken() != null;
    initialRoute = hasValidToken ? RouteHelper.homeScreen : RouteHelper.onboardScreen;
  } else {
    final apiService = ApiService();
    // If internet is available, check maintenance mode
    final maintenanceResponse = await apiService.checkMaintenanceMode();

    if (maintenanceResponse.isInMaintenance && maintenanceResponse.success) {
      // Get the controller and update it with maintenance data
      final maintenanceController = Get.find<MaintenanceController>();
      maintenanceController.updateMaintenanceData(
        heading: maintenanceResponse.heading,
        description: maintenanceResponse.description,
        estimatedTime: maintenanceResponse.estimatedTime,
      );
      initialRoute = '/maintenance';
    } else {
      final hasValidToken = LocalStorage.getToken() != null;
      initialRoute = hasValidToken ? RouteHelper.homeScreen : RouteHelper.onboardScreen;
    }
  }

  runApp(MainApp(initialRoute: initialRoute));
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
        getPages: _buildRoutes(),
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

  List<GetPage> _buildRoutes() {
    // Add maintenance route to existing routes
    final routes = List<GetPage>.from(RouteHelper.routes);

    // Add maintenance screen route
    routes.add(
      GetPage(
        name: '/maintenance',
        page: () => const MaintenanceScreen(),
        transition: Transition.fadeIn,
      ),
    );

    return routes;
  }
}

// Optional: Create a splash screen with maintenance check
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkMaintenanceAndNavigate();
  }

  Future<void> _checkMaintenanceAndNavigate() async {
    // Add a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check internet connectivity first
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool hasInternet = connectivityResult != ConnectivityResult.none;

    if (!hasInternet) {
      // If no internet, proceed with normal app flow
      final hasValidToken = LocalStorage.getToken() != null;
      if (hasValidToken) {
        Get.offAllNamed(RouteHelper.homeScreen);
      } else {
        Get.offAllNamed(RouteHelper.onboardScreen);
      }
      return;
    }

    final apiService = ApiService();
    final maintenanceResponse = await apiService.checkMaintenanceMode();

    if (maintenanceResponse.isInMaintenance && maintenanceResponse.success) {
      // Navigate to maintenance screen only if we successfully got a maintenance response
      Get.offAllNamed('/maintenance');
    } else {
      // Check authentication and navigate accordingly
      final hasValidToken = LocalStorage.getToken() != null;
      if (hasValidToken) {
        Get.offAllNamed(RouteHelper.homeScreen);
      } else {
        Get.offAllNamed(RouteHelper.onboardScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7ED321),
              Color(0xFF4CAF50),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.monetization_on,
                  size: 50,
                  color: Color(0xFF7ED321),
                ),
              ),

              const SizedBox(height: 30),

              // App name
              Text(
                MyStrings.appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),

              const SizedBox(height: 20),

              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}