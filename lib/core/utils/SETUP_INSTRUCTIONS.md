# تعليمات إعداد الـ API

## الخطوات المطلوبة

### 1. تثبيت Dependencies
```bash
flutter pub get
```

### 2. التأكد من تشغيل الـ API المحلي
- تأكد من تشغيل الخادم على `http://127.0.0.1:8000`
- تأكد من صحة الـ API endpoints

### 3. اختبار الاتصال
```dart
// في أي مكان في التطبيق
final networkInfo = NetworkInfo();
final hasConnection = await networkInfo.hasConnection();
print('الاتصال بالإنترنت: $hasConnection');

final canReachServer = await networkInfo.canReachServer('http://127.0.0.1:8000');
print('يمكن الوصول للخادم: $canReachServer');
```

## اختبار العمليات

### 1. اختبار التسجيل
```dart
final authRepo = sl<AuthRepository>();
final request = RegisterRequest(
  name: 'اختبار',
  email: 'test@example.com',
  password: 'password123',
  passwordConfirmation: 'password123',
);

try {
  final response = await authRepo.register(request);
  print('النتيجة: ${response.isSuccess}');
  print('الرسالة: ${response.msg}');
} catch (e) {
  print('خطأ: $e');
}
```

### 2. اختبار تسجيل الدخول
```dart
final authRepo = sl<AuthRepository>();
final request = LoginRequest(
  email: 'test@example.com',
  password: 'password123',
);

try {
  final response = await authRepo.login(request);
  print('النتيجة: ${response.isSuccess}');
  if (response.isSuccess) {
    print('المستخدم: ${response.data?.user.name}');
    print('الرمز: ${response.data?.token}');
  }
} catch (e) {
  print('خطأ: $e');
}
```

### 3. اختبار الفلترة
```dart
final filterRepo = sl<FilterRepository>();

// الحصول على التفاصيل
try {
  final response = await filterRepo.getDetails();
  print('المدن: ${response.data?.cities.length}');
  print('العلامات: ${response.data?.tags.length}');
} catch (e) {
  print('خطأ: $e');
}

// البحث
try {
  final request = FilterRequest(
    q: 'فندق',
    cityId: 2,
  );
  final response = await filterRepo.filter(request);
  print('الفعاليات: ${response.data?.events.length}');
  print('الفنادق: ${response.data?.hotels.length}');
} catch (e) {
  print('خطأ: $e');
}
```

## استكشاف الأخطاء

### 1. مشاكل الاتصال
- تأكد من تشغيل الخادم
- تحقق من عنوان الـ URL
- تأكد من الاتصال بالإنترنت

### 2. مشاكل المصادقة
- تحقق من صحة البيانات
- تأكد من وجود المستخدم في قاعدة البيانات
- تحقق من صحة الرمز المميز

### 3. مشاكل البيانات
- تحقق من صحة الـ JSON
- تأكد من تطابق الـ Models
- راجع رسائل الخطأ

## نصائح للتطوير

### 1. استخدام Logging
- جميع الطلبات والاستجابات مسجلة
- راجع Console للتفاصيل
- استخدم Debug mode للتطوير

### 2. إدارة الحالة
- استخدم Cubit/Bloc لإدارة الحالة
- احفظ البيانات محلياً عند الحاجة
- استخدم Loading states

### 3. معالجة الأخطاء
- اعرض رسائل خطأ واضحة للمستخدم
- استخدم Try-catch blocks
- تعامل مع حالات الشبكة المختلفة

## التطوير المستقبلي

### 1. إضافة عمليات جديدة
- اتبع نفس النمط الموجود
- أنشئ Models جديدة حسب الحاجة
- أضف Repository methods جديدة

### 2. تحسينات الأداء
- أضف التخزين المؤقت
- استخدم Pagination للبيانات الكبيرة
- ضغط البيانات عند الحاجة

### 3. الأمان
- استخدم HTTPS في الإنتاج
- أضف التحقق من البيانات
- استخدم Rate limiting
