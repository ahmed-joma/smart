# API Architecture Overview

## البنية العامة

```
lib/core/utils/
├── constants/
│   └── api_constants.dart          # URLs والثوابت
├── models/
│   ├── api_response.dart           # نموذج الاستجابة العامة
│   ├── api_error.dart             # نموذج الأخطاء
│   ├── auth_models.dart           # نماذج المصادقة
│   └── filter_models.dart         # نماذج الفلترة
├── repositories/
│   ├── auth_repository.dart        # عمليات المصادقة
│   └── filter_repository.dart      # عمليات الفلترة
├── api_service.dart               # الخدمة الرئيسية للـ HTTP
├── token_manager.dart             # إدارة الرموز المميزة
├── network_info.dart              # فحص الاتصال
├── service_locator.dart           # إدارة الـ Dependencies
├── exceptions.dart                # أنواع الأخطاء المخصصة
├── api_usage_example.dart         # أمثلة الاستخدام
└── README.md                      # التوثيق
```

## تدفق البيانات

### 1. تسجيل الدخول
```
UI → AuthRepository → ApiService → Server
                ↓
            TokenManager (حفظ الرمز)
                ↓
            Response → UI
```

### 2. الفلترة
```
UI → FilterRepository → ApiService → Server
                ↓
            Response → UI
```

## المكونات الرئيسية

### ApiService
- إدارة HTTP requests باستخدام Dio
- إضافة الرموز المميزة تلقائياً
- معالجة الأخطاء والتسجيل
- إدارة المهلات الزمنية

### TokenManager
- حفظ واسترجاع الرموز المميزة
- إدارة بيانات المستخدم
- فحص حالة تسجيل الدخول

### Repositories
- طبقة تجريد بين UI والـ API
- معالجة منطق العمل
- تحويل البيانات

### Models
- نماذج البيانات المحددة
- تحويل JSON
- التحقق من صحة البيانات

## الأمان

### الرموز المميزة
- حفظ آمن في SharedPreferences
- إضافة تلقائية للطلبات المحمية
- مسح عند تسجيل الخروج

### التحقق
- التحقق من البيانات قبل الإرسال
- معالجة أخطاء الخادم
- رسائل خطأ واضحة

## الأداء

### التخزين المؤقت
- حفظ البيانات محلياً
- تقليل الطلبات للخادم
- تحسين تجربة المستخدم

### الشبكة
- فحص الاتصال
- إدارة المهلات
- إعادة المحاولة

## التطوير المستقبلي

### إضافة عمليات جديدة
- تحديث الملف الشخصي
- إدارة المفضلة
- الحجز والدفع

### تحسينات
- التخزين المؤقت المتقدم
- ضغط البيانات
- مراقبة الأداء
