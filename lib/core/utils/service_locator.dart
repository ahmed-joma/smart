import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/filter_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/home_repository.dart';
import '../../features/Event_Details/data/repos/event_repository.dart'
    as event_details;
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
  sl.registerLazySingleton(() => TokenManager.instance);
  sl.registerLazySingleton(() => ApiService());

  // Repository
  sl.registerLazySingleton(() => AuthRepository());
  sl.registerLazySingleton(() => FilterRepository());
  sl.registerLazySingleton(() => ProfileRepository());
  sl.registerLazySingleton(() => HomeRepository());
  sl.registerLazySingleton<event_details.EventRepository>(
    () => event_details.EventRepositoryImpl(),
  );
  sl.registerLazySingleton(() => OrderRepository());
  sl.registerLazySingleton(() => HotelRepository());
  sl.registerLazySingleton(() => FavoriteRepository());

  // Initialize services
  await sl<TokenManager>().initialize();
  sl<ApiService>().initialize();
  sl<ApiService>().setTokenManager(sl<TokenManager>());

  // Load token from storage
  await sl<ApiService>().loadToken();

  print('✅ Service Locator initialized successfully');
}

// Reset function for hot reload
void resetServiceLocator() {
  sl.reset();
  print('🔄 Service Locator Reset');
}
