import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/filter_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/home_repository.dart';
import 'repositories/event_repository.dart';
import 'repositories/order_repository.dart';
import 'repositories/hotel_repository.dart';
import 'repositories/favorite_repository.dart';
import 'token_manager.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => TokenManager.instance);

  // Repository
  sl.registerLazySingleton(() => AuthRepository());
  sl.registerLazySingleton(() => FilterRepository());
  sl.registerLazySingleton(() => ProfileRepository());
  sl.registerLazySingleton(() => HomeRepository());
  sl.registerLazySingleton(() => EventRepository());
  sl.registerLazySingleton(() => OrderRepository());
  sl.registerLazySingleton(() => HotelRepository());
  sl.registerLazySingleton(() => FavoriteRepository());

  // Initialize services
  await sl<TokenManager>().initialize();
  sl<ApiService>().initialize();
}

// Reset function for hot reload
void resetServiceLocator() {
  sl.reset();
  print('🔄 Service Locator Reset');
}
