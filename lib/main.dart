import 'package:flutter/material.dart';
import 'shared/shared.dart';
import 'core/utils/app_routers.dart';

void main() {
  runApp(const SmartShopMap());
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
