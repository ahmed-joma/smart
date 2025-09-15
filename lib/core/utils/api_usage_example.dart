import 'service_locator.dart';
import 'repositories/auth_repository.dart';
import 'repositories/filter_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/home_repository.dart';
import 'repositories/event_repository.dart';
import 'repositories/order_repository.dart';
import 'repositories/hotel_repository.dart';
import 'repositories/favorite_repository.dart';
import 'models/auth_models.dart';
import 'models/filter_models.dart';
import 'models/order_models.dart';

/// مثال على كيفية استخدام الـ API في التطبيق
class ApiUsageExample {
  final AuthRepository _authRepository = sl<AuthRepository>();
  final FilterRepository _filterRepository = sl<FilterRepository>();

  /// مثال على تسجيل مستخدم جديد
  Future<void> registerUser() async {
    try {
      final request = RegisterRequest(
        name: 'أحمد محمد',
        email: 'ahmed@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
        phone: '+966501234567',
      );

      final response = await _authRepository.register(request);

      if (response.isSuccess) {
        print('تم التسجيل بنجاح!');
        print('المستخدم: ${response.data?.user.name}');
        print('الرمز: ${response.data?.token}');
      } else {
        print('فشل في التسجيل: ${response.msg}');
      }
    } catch (e) {
      print('خطأ في التسجيل: $e');
    }
  }

  /// مثال على تسجيل الدخول
  Future<void> loginUser() async {
    try {
      final request = LoginRequest(
        email: 'ahmed@example.com',
        password: 'password123',
      );

      final response = await _authRepository.login(request);

      if (response.isSuccess) {
        print('تم تسجيل الدخول بنجاح!');
        print('المستخدم: ${response.data?.user.name}');
      } else {
        print('فشل في تسجيل الدخول: ${response.msg}');
      }
    } catch (e) {
      print('خطأ في تسجيل الدخول: $e');
    }
  }

  /// مثال على الحصول على تفاصيل الفلترة
  Future<void> getFilterDetails() async {
    try {
      final response = await _filterRepository.getDetails();

      if (response.isSuccess && response.data != null) {
        print('المدن المتاحة:');
        for (final city in response.data!.cities) {
          print('- ${city.name}');
        }

        print('\nالعلامات المتاحة:');
        for (final tag in response.data!.tags) {
          print('- ${tag.name}');
        }
      } else {
        print('فشل في الحصول على التفاصيل: ${response.msg}');
      }
    } catch (e) {
      print('خطأ في الحصول على التفاصيل: $e');
    }
  }

  /// مثال على البحث والفلترة
  Future<void> searchAndFilter() async {
    try {
      // البحث عن فندق في الرياض
      final request = FilterRequest(
        q: 'فندق',
        cityId: 2, // الرياض
        priceMin: 100,
        priceMax: 500,
        tags: [1, 6], // Sports, Luxury
      );

      final response = await _filterRepository.filter(request);

      if (response.isSuccess && response.data != null) {
        print('النتائج:');
        print('الفعاليات: ${response.data!.events.length}');
        print('الفنادق: ${response.data!.hotels.length}');

        // عرض الفنادق
        for (final hotel in response.data!.hotels) {
          print(
            'فندق: ${hotel.name} - ${hotel.city} - ${hotel.pricePerNight} ريال',
          );
        }
      } else {
        print('فشل في البحث: ${response.msg}');
      }
    } catch (e) {
      print('خطأ في البحث: $e');
    }
  }

  /// مثال على تسجيل الخروج
  Future<void> logoutUser() async {
    try {
      final response = await _authRepository.logout();

      if (response.isSuccess) {
        print('تم تسجيل الخروج بنجاح!');
      } else {
        print('فشل في تسجيل الخروج: ${response.msg}');
      }
    } catch (e) {
      print('خطأ في تسجيل الخروج: $e');
    }
  }
}

/// مثال على الحصول على بيانات الصفحة الرئيسية
Future<void> getHomeData() async {
  try {
    final homeRepo = sl<HomeRepository>();
    final response = await homeRepo.getHomeData();

    if (response.isSuccess && response.data != null) {
      print('الفعاليات المميزة: ${response.data!.featuredEvents.length}');
      print('الفنادق المميزة: ${response.data!.featuredHotels.length}');
      print('الفئات: ${response.data!.categories.length}');
      print('التوصيات: ${response.data!.recommendations.length}');
    } else {
      print('فشل في الحصول على بيانات الصفحة الرئيسية: ${response.msg}');
    }
  } catch (e) {
    print('خطأ في الحصول على بيانات الصفحة الرئيسية: $e');
  }
}

/// مثال على الحصول على تفاصيل فعالية
Future<void> getEventDetails(int eventId) async {
  try {
    final eventRepo = sl<EventRepository>();
    final response = await eventRepo.getEventDetails(eventId);

    if (response.isSuccess && response.data != null) {
      print('اسم الفعالية: ${response.data!.venue}');
      print('المدينة: ${response.data!.cityName}');
      print('التاريخ: ${response.data!.formattedStartAt}');
    } else {
      print('فشل في الحصول على تفاصيل الفعالية: ${response.msg}');
    }
  } catch (e) {
    print('خطأ في الحصول على تفاصيل الفعالية: $e');
  }
}

/// مثال على الحصول على جميع الفنادق
Future<void> getAllHotels() async {
  try {
    final hotelRepo = sl<HotelRepository>();
    final response = await hotelRepo.getAllHotels();

    if (response.isSuccess && response.data != null) {
      print('عدد الفنادق: ${response.data!.length}');
      for (final hotel in response.data!) {
        print(
          'فندق: ${hotel.name} - ${hotel.city} - ${hotel.pricePerNight} ريال',
        );
      }
    } else {
      print('فشل في الحصول على الفنادق: ${response.msg}');
    }
  } catch (e) {
    print('خطأ في الحصول على الفنادق: $e');
  }
}

/// مثال على إضافة فعالية للمفضلة
Future<void> addEventToFavorites(int eventId) async {
  try {
    final favoriteRepo = sl<FavoriteRepository>();
    final response = await favoriteRepo.addEventToFavorites(eventId);

    if (response.isSuccess && response.data != null) {
      print('تم إضافة الفعالية للمفضلة: ${response.data!.isFavorite}');
      print('الرسالة: ${response.data!.message}');
    } else {
      print('فشل في إضافة الفعالية للمفضلة: ${response.msg}');
    }
  } catch (e) {
    print('خطأ في إضافة الفعالية للمفضلة: $e');
  }
}

/// مثال على إنشاء طلب
Future<void> createOrder() async {
  try {
    final orderRepo = sl<OrderRepository>();
    final request = CreateOrderRequest(
      items: [
        OrderItemRequest(type: 'event', itemId: 1, quantity: 2),
        OrderItemRequest(type: 'hotel', itemId: 1, quantity: 1),
      ],
      paymentMethod: 'credit_card',
      notes: 'طلب تجريبي',
    );

    final response = await orderRepo.createOrder(request);

    if (response.isSuccess && response.data != null) {
      print('تم إنشاء الطلب بنجاح!');
      print('رقم الطلب: ${response.data!.id}');
      print(
        'المبلغ الإجمالي: ${response.data!.totalAmount} ${response.data!.currency}',
      );
      print('الحالة: ${response.data!.status}');
    } else {
      print('فشل في إنشاء الطلب: ${response.msg}');
    }
  } catch (e) {
    print('خطأ في إنشاء الطلب: $e');
  }
}

/// مثال على الحصول على الملف الشخصي
Future<void> getProfile() async {
  try {
    final profileRepo = sl<ProfileRepository>();
    final response = await profileRepo.getProfile();

    if (response.isSuccess && response.data != null) {
      print('الاسم: ${response.data!.name}');
      print('البريد الإلكتروني: ${response.data!.email}');
      print('الهاتف: ${response.data!.phone ?? 'غير محدد'}');
      print('تم التحقق من البريد: ${response.data!.isEmailVerified}');
    } else {
      print('فشل في الحصول على الملف الشخصي: ${response.msg}');
    }
  } catch (e) {
    print('خطأ في الحصول على الملف الشخصي: $e');
  }
}

/// مثال على تحديث الملف الشخصي
Future<void> updateProfile() async {
  try {
    final profileRepo = sl<ProfileRepository>();
    final response = await profileRepo.updateProfile(
      name: 'أحمد محمد المحدث',
      phone: '+966501234567',
    );

    if (response.isSuccess && response.data != null) {
      print('تم تحديث الملف الشخصي بنجاح!');
      print('الاسم الجديد: ${response.data!.name}');
      print('الهاتف الجديد: ${response.data!.phone}');
    } else {
      print('فشل في تحديث الملف الشخصي: ${response.msg}');
    }
  } catch (e) {
    print('خطأ في تحديث الملف الشخصي: $e');
  }
}

/// مثال على استخدام الـ API في Cubit/Bloc
class ExampleCubit {
  final AuthRepository _authRepository = sl<AuthRepository>();
  final FilterRepository _filterRepository = sl<FilterRepository>();
  final HomeRepository _homeRepository = sl<HomeRepository>();

  /// تسجيل الدخول مع إدارة الحالة
  Future<void> login(String email, String password) async {
    try {
      // إظهار loading
      // emit(LoginLoading());

      final request = LoginRequest(email: email, password: password);
      final response = await _authRepository.login(request);

      if (response.isSuccess) {
        // حفظ بيانات المستخدم محلياً
        // await _saveUserLocally(response.data!.user);

        // إرسال حالة النجاح
        // emit(LoginSuccess(response.data!.user));
      } else {
        // إرسال حالة الخطأ
        // emit(LoginError(response.msg));
      }
    } catch (e) {
      // إرسال حالة الخطأ
      // emit(LoginError(e.toString()));
    }
  }

  /// الحصول على المدن مع إدارة الحالة
  Future<void> loadCities() async {
    try {
      // emit(CitiesLoading());

      final cities = await _filterRepository.getCities();

      // emit(CitiesLoaded(cities));
      print('تم تحميل ${cities.length} مدينة');
    } catch (e) {
      // emit(CitiesError(e.toString()));
    }
  }

  /// تحميل بيانات الصفحة الرئيسية
  Future<void> loadHomeData() async {
    try {
      // emit(HomeLoading());

      final response = await _homeRepository.getHomeData();

      if (response.isSuccess) {
        // emit(HomeLoaded(response.data!));
      } else {
        // emit(HomeError(response.msg));
      }
    } catch (e) {
      // emit(HomeError(e.toString()));
    }
  }
}
