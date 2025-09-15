# API Integration Documentation

## نظرة عامة
تم إنشاء نظام متكامل للتعامل مع الـ API المحلي للتطبيق. يتضمن النظام جميع العمليات المطلوبة للمصادقة والفلترة.

## البنية

### 1. Constants
- `api_constants.dart`: يحتوي على جميع الـ URLs والثوابت المطلوبة

### 2. Models
- `api_response.dart`: نموذج الاستجابة العامة من الـ API
- `api_error.dart`: نموذج معالجة الأخطاء
- `auth_models.dart`: نماذج المصادقة (User, AuthResponse, etc.)
- `filter_models.dart`: نماذج الفلترة (City, Tag, Event, Hotel)

### 3. Services
- `api_service.dart`: الخدمة الرئيسية للتعامل مع HTTP requests
- `token_manager.dart`: إدارة الرموز المميزة والتخزين المحلي
- `network_info.dart`: فحص حالة الاتصال بالإنترنت

### 4. Repositories
- `auth_repository.dart`: عمليات المصادقة (تسجيل، دخول، خروج، إلخ)
- `filter_repository.dart`: عمليات الفلترة والبحث

### 5. Utils
- `service_locator.dart`: تسجيل وإدارة الـ Dependencies
- `exceptions.dart`: أنواع الأخطاء المخصصة

## كيفية الاستخدام

### 1. تهيئة النظام
```dart
// في main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(const SmartShopMap());
}
```

### 2. تسجيل مستخدم جديد
```dart
final authRepo = sl<AuthRepository>();
final request = RegisterRequest(
  name: 'أحمد محمد',
  email: 'ahmed@example.com',
  password: 'password123',
  passwordConfirmation: 'password123',
);

final response = await authRepo.register(request);
if (response.isSuccess) {
  // تم التسجيل بنجاح
  print('المستخدم: ${response.data?.user.name}');
}
```

### 3. تسجيل الدخول
```dart
final authRepo = sl<AuthRepository>();
final request = LoginRequest(
  email: 'ahmed@example.com',
  password: 'password123',
);

final response = await authRepo.login(request);
if (response.isSuccess) {
  // تم تسجيل الدخول بنجاح
  // الرمز المميز سيتم حفظه تلقائياً
}
```

### 4. الحصول على تفاصيل الفلترة
```dart
final filterRepo = sl<FilterRepository>();
final response = await filterRepo.getDetails();

if (response.isSuccess) {
  final cities = response.data!.cities;
  final tags = response.data!.tags;
  // استخدام المدن والعلامات في الواجهة
}
```

### 5. البحث والفلترة
```dart
final filterRepo = sl<FilterRepository>();
final request = FilterRequest(
  q: 'فندق',
  cityId: 2, // الرياض
  priceMin: 100,
  priceMax: 500,
  tags: [1, 6], // Sports, Luxury
);

final response = await filterRepo.filter(request);
if (response.isSuccess) {
  final events = response.data!.events;
  final hotels = response.data!.hotels;
  // عرض النتائج
}
```

### 5. الحصول على بيانات الصفحة الرئيسية
```dart
final homeRepo = sl<HomeRepository>();
final response = await homeRepo.getHomeData();

if (response.isSuccess) {
  final featuredEvents = response.data!.featuredEvents;
  final featuredHotels = response.data!.featuredHotels;
  final categories = response.data!.categories;
  final recommendations = response.data!.recommendations;
  // عرض البيانات في الصفحة الرئيسية
}
```

### 6. إدارة الملف الشخصي
```dart
final profileRepo = sl<ProfileRepository>();

// الحصول على الملف الشخصي
final profileResponse = await profileRepo.getProfile();
if (profileResponse.isSuccess) {
  final user = profileResponse.data!;
  // عرض بيانات المستخدم
}

// تحديث الملف الشخصي
final updateResponse = await profileRepo.updateProfile(
  name: 'الاسم الجديد',
  phone: '+966501234567',
);
```

### 7. إدارة الطلبات
```dart
final orderRepo = sl<OrderRepository>();

// إنشاء طلب جديد
final request = CreateOrderRequest(
  items: [
    OrderItemRequest(type: 'event', itemId: 1, quantity: 2),
    OrderItemRequest(type: 'hotel', itemId: 1, quantity: 1),
  ],
  paymentMethod: 'credit_card',
);

final response = await orderRepo.createOrder(request);
if (response.isSuccess) {
  final order = response.data!;
  // عرض تفاصيل الطلب
}

// الحصول على طلبات المستخدم
final ordersResponse = await orderRepo.getUserOrders();
if (ordersResponse.isSuccess) {
  final orders = ordersResponse.data!;
  // عرض قائمة الطلبات
}
```

### 8. إدارة المفضلة
```dart
final favoriteRepo = sl<FavoriteRepository>();

// إضافة فعالية للمفضلة
final response = await favoriteRepo.addEventToFavorites(eventId);
if (response.isSuccess) {
  final isFavorite = response.data!.isFavorite;
  // تحديث واجهة المستخدم
}

// إضافة فندق للمفضلة
await favoriteRepo.addHotelToFavorites(hotelId);
```

### 9. الحصول على تفاصيل الفنادق والفعاليات
```dart
final hotelRepo = sl<HotelRepository>();
final eventRepo = sl<EventRepository>();

// الحصول على جميع الفنادق
final hotelsResponse = await hotelRepo.getAllHotels();
if (hotelsResponse.isSuccess) {
  final hotels = hotelsResponse.data!;
  // عرض قائمة الفنادق
}

// الحصول على تفاصيل فندق محدد
final hotelDetails = await hotelRepo.getHotelDetails(hotelId);

// الحصول على تفاصيل فعالية محددة
final eventDetails = await eventRepo.getEventDetails(eventId);
```

## الميزات

### 1. إدارة الرموز المميزة
- حفظ الرمز المميز تلقائياً عند تسجيل الدخول
- إضافة الرمز المميز تلقائياً لجميع الطلبات المحمية
- مسح الرمز المميز عند تسجيل الخروج

### 2. معالجة الأخطاء
- معالجة شاملة للأخطاء مع رسائل واضحة
- دعم لأكواد الاستجابة المختلفة
- تسجيل مفصل للطلبات والاستجابات

### 3. إدارة الحالة
- دعم كامل لـ GetIt للـ Dependency Injection
- إدارة محلية للبيانات باستخدام SharedPreferences

### 4. الشبكة
- فحص الاتصال بالإنترنت
- إدارة المهلات الزمنية
- إعادة المحاولة التلقائية

## الأمان

### 1. الرموز المميزة
- حفظ آمن للرموز المميزة
- إضافة تلقائية للرموز في الطلبات المحمية
- مسح الرموز عند تسجيل الخروج

### 2. التحقق
- التحقق من صحة البيانات قبل الإرسال
- معالجة أخطاء التحقق من الخادم

## التطوير المستقبلي

### 1. إضافة المزيد من العمليات
- ✅ تحديث الملف الشخصي
- ✅ إدارة المفضلة
- ✅ إدارة الطلبات
- ✅ الحصول على بيانات الصفحة الرئيسية
- ✅ تفاصيل الفنادق والفعاليات
- إضافة المزيد من عمليات الدفع
- إشعارات المستخدمين

### 2. تحسينات الأداء
- التخزين المؤقت للبيانات
- ضغط البيانات
- تحسين استهلاك البيانات

### 3. المراقبة
- تتبع الأخطاء
- إحصائيات الاستخدام
- مراقبة الأداء
