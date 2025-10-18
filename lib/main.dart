import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'shared/shared.dart';
import 'core/utils/app_routers.dart';
import 'core/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Mapbox with access token
  MapboxOptions.setAccessToken(
    "pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",
  );

  await initServiceLocator();
  runApp(const SmartShopMap());
}

// Reset function for hot reload
void resetApp() {
  resetServiceLocator();
  print('🔄 App Reset - All Services Reset');
}

class SmartShopMap extends StatelessWidget {
  const SmartShopMap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouters.router,
    );
  }
}
