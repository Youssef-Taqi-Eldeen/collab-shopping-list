# Forgot Password Feature - User Guide

## كيفية عمل الميزة

تم تنفيذ ميزة "نسيت كلمة المرور" بطريقتين:

### 1️⃣ **الطريقة الافتراضية (Firebase Email Link)**
هذه هي الطريقة المستخدمة حالياً في التطبيق:

**الخطوات:**
1. المستخدم يضغط على "Forgot Password?" في شاشة تسجيل الدخول
2. يدخل الإيميل ويضغط "Send Reset Link"
3. Firebase يرسل ايميل يحتوي على **رابط** لتغيير كلمة المرور
4. المستخدم يفتح الرابط من الإيميل
5. الرابط يحتوي على `code` في الـ URL
6. يتم استخراج الـ code واستخدامه في `ResetPasswordScreen`
7. المستخدم يدخل كلمة المرور الجديدة ويأكدها
8. يتم تغيير كلمة المرور باستخدام `confirmPasswordReset`

**مميزات هذه الطريقة:**
- آمنة تماماً
- موثوقة من Firebase
- تعمل على جميع المنصات (Web, Mobile)
- لا تحتاج تخزين أكواد إضافية

**ملاحظة مهمة للتطبيقات على الويب:**
- الرابط المرسل من Firebase يفتح صفحة ويب خاصة بـ Firebase افتراضياً
- لتوجيه المستخدم لتطبيقك، يجب إعداد **Dynamic Links** أو **Custom Email Action Handler**

### 2️⃣ **طريقة بديلة (رمز 6 أرقام - للتطبيقات المغلقة)**
إذا كنت تريد أن يبقى المستخدم داخل التطبيق بدون الحاجة لفتح رابط خارجي:

**التنفيذ:**
1. إنشاء رمز عشوائي من 6 أرقام
2. تخزينه في Firestore مع الإيميل ووقت الانتهاء
3. إرسال الرمز عبر خدمة إيميل خارجية (SendGrid, Mailgun, إلخ)
4. المستخدم يدخل الرمز في شاشة التحقق
5. التحقق من الرمز في Firestore
6. استخدام `updatePassword()` لتغيير كلمة المرور للمستخدم بعد تسجيل دخوله مؤقتاً

**عيوب هذه الطريقة:**
- تحتاج خدمة إيميل خارجية مدفوعة
- أكثر تعقيداً في التنفيذ
- تحتاج Firebase Functions للأمان

## الحل المطبق حالياً

تم تنفيذ **الطريقة 1** (Firebase Email Link) لأنها:
- ✅ مجانية تماماً
- ✅ آمنة ومدمجة مع Firebase
- ✅ لا تحتاج خدمات خارجية
- ✅ سهلة التنفيذ والصيانة

## كيفية التكامل مع الويب

لكي يعمل الرابط داخل تطبيقك على الويب:

1. **في Firebase Console:**
   - اذهب إلى Authentication > Templates > Password Reset
   - اختر "Customize action URL"
   - أضف URL التطبيق الخاص بك: `https://your-app.com/__/auth/action`

2. **في التطبيق:**
   - قم بإنشاء route يستقبل الـ `mode` و `oobCode` من الـ URL
   - مثال: `/reset-password?mode=resetPassword&oobCode=ABC123`
   - استخرج الـ `oobCode` وأرسله لـ `ResetPasswordScreen(code: oobCode)`

## الملفات المعدلة

1. **lib/core/provider/auth_app.dart**
   - أضيف method: `sendPasswordResetEmail()`
   - أضيف method: `confirmPasswordReset()`

2. **lib/features/auth/presentation/view/forgot_password_view.dart**
   - شاشة إدخال الإيميل
   - تايمر 60 ثانية للحماية من الإزعاج
   - معالجة الأخطاء

3. **lib/features/auth/presentation/view/reset_password_view.dart**
   - شاشة إدخال كلمة المرور الجديدة
   - القبول بـ `code` parameter
   - استخدام `confirmPasswordReset` لتغيير كلمة المرور

4. **lib/features/auth/presentation/view/login_view.dart**
   - ربط زر "Forgot Password?" بشاشة ForgotPassword

## خطوات الاختبار

### للاختبار الأولي (بدون deep linking):
1. اضغط "Forgot Password" في شاشة Login
2. أدخل إيميل صحيح ومسجل
3. اضغط "Send Reset Link"
4. افتح الإيميل من Gmail
5. اضغط على الرابط
6. **سيفتح صفحة Firebase الافتراضية** لتغيير كلمة المرور
7. غير كلمة المرور هناك
8. ارجع للتطبيق وسجل دخول بكلمة المرور الجديدة

### للاختبار المتقدم (مع deep linking):
يحتاج إعداد Firebase Dynamic Links أو Custom Domain.

## ملاحظات الأمان

⚠️ **Email Enumeration Protection:**
- بشكل افتراضي، Firebase لا يخبرك إذا كان الإيميل غير موجود (لحماية الخصوصية)
- إذا أردت إظهار خطأ "Email not found"، قم بتعطيل الحماية من Firebase Console

## الدعم والمساعدة

إذا واجهت أي مشكلة:
1. تأكد من إعدادات Firebase Authentication
2. تحقق من قواعد Firestore Security Rules
3. افحص Console للأخطاء
