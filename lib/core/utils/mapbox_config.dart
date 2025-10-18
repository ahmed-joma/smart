class MapboxConfig {
  static const String accessToken =
      'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw';

  static Future<void> initialize() async {
    try {
      // Mapbox initialization is handled automatically by the plugin
      // The token is configured in AndroidManifest.xml
      print('✅ Mapbox configuration loaded');
      print('🗝️ Access Token: ${accessToken.substring(0, 20)}...');
    } catch (e) {
      print('❌ Error configuring Mapbox: $e');
    }
  }
}
