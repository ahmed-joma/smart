import 'package:flutter/material.dart';
import 'shared/shared.dart';
import 'core/utils/app_routers.dart';
import 'core/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
