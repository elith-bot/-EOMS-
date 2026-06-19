# 📱 خطة استكمال Frontend (Flutter)

## ✅ ما الموجود حالياً في Flutter

### الملفات الموجودة:
```
✅ pubspec.yaml          - Dependencies و Configuration
✅ lib/main.dart         - Entry Point
✅ lib/src/app.dart      - Material App Setup
✅ lib/src/screens/login_screen.dart       - شاشة التسجيل
✅ lib/src/screens/home_screen.dart        - شاشة البيت (فارغة)
✅ lib/src/services/api_service.dart       - API Connection
```

### APIs الموجودة:
```
✅ login()     - تسجيل الدخول
```

---

## ⏳ ما الناقص في Frontend

### 1️⃣ Screens (7 screens إضافية)
```
❌ HomeScreen           - الصفحة الرئيسية (Dashboard)
❌ ProfileScreen        - ملف المستخدم الشخصي
❌ GradesScreen         - شاشة الدرجات
❌ AttendanceScreen     - شاشة الحضور والغياب
❌ FinanceScreen        - شاشة الأقساط المالية
❌ ScheduleScreen       - شاشة جدول الدروس
❌ SettingsScreen       - الإعدادات
```

### 2️⃣ Navigation & Routing
```
❌ Navigation Bar أسفل الشاشة
❌ Routing بين الشاشات
❌ Bottom Navigation
```

### 3️⃣ State Management
```
❌ Provider for Global State
❌ User Data Storage (Shared Preferences)
❌ Token Management
```

### 4️⃣ Features الإضافية
```
❌ User Authentication State
❌ Offline Mode
❌ Local Caching
❌ Error Handling
❌ Loading States
```

---

## 🚀 خطة الاستكمال

### المرحلة الأولى: تحسين HomeScreen (1-2 ساعة)

#### 1.1 تحديث pubspec.yaml
أضف المكتبات التالية:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.14.0
  provider: ^6.0.0
  shared_preferences: ^2.0.0
  intl: ^0.17.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

#### 1.2 إنشاء Models
أنشئ ملف `lib/src/models/user_model.dart`:
```dart
class User {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final int institutionId;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.institutionId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'] ?? json['email'],
      role: json['role'],
      institutionId: json['institution_id'],
    );
  }
}
```

#### 1.3 إنشاء AuthProvider
أنشئ ملف `lib/src/providers/auth_provider.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<bool> login(String email, String password, String userType) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password, userType);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        _user = User.fromJson(data['user']);
        
        // حفظ البيانات محلياً
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(data['user']));
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
    }
    notifyListeners();
  }
}
```

#### 1.4 تحديث App.dart مع Provider
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';

class ElmApp extends StatelessWidget {
  const ElmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
      ],
      child: MaterialApp(
        title: 'ELM Educational Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isAuthenticated
                ? const HomeScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
```

---

### المرحلة الثانية: إنشاء HomeScreen (1-2 ساعة)

أنشئ ملف `lib/src/screens/home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'الصفحة الرئيسية',
    'الدرجات',
    'الحضور',
    'الأقساط',
    'الحساب',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),
      body: Center(
        child: _buildPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grades),
            label: 'الدرجات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'الحضور',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'الأقساط',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الحساب',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildGrades();
      case 2:
        return _buildAttendance();
      case 3:
        return _buildFinance();
      case 4:
        return _buildProfile();
      default:
        return Container();
    }
  }

  Widget _buildDashboard() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مرحباً
              Text(
                'مرحباً, ${authProvider.user?.fullName}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              // بطاقات المعلومات
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildInfoCard('الدرجات', '85', Icons.grades, Colors.blue),
                  _buildInfoCard('الحضور', '92%', Icons.check_circle, Colors.green),
                  _buildInfoCard('الأقساط', '5000 دينار', Icons.payment, Colors.orange),
                  _buildInfoCard('الدروس', '6 مواد', Icons.book, Colors.purple),
                ],
              ),
              const SizedBox(height: 20),

              // زر تسجيل الخروج
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(45),
                ),
                onPressed: () {
                  authProvider.logout();
                },
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrades() {
    return const Center(
      child: Text('شاشة الدرجات - قيد الإنشاء'),
    );
  }

  Widget _buildAttendance() {
    return const Center(
      child: Text('شاشة الحضور - قيد الإنشاء'),
    );
  }

  Widget _buildFinance() {
    return const Center(
      child: Text('شاشة الأقساط - قيد الإنشاء'),
    );
  }

  Widget _buildProfile() {
    return const Center(
      child: Text('شاشة الحساب - قيد الإنشاء'),
    );
  }
}
```

---

## 📋 خطوات التطبيق

### الخطوة 1: تحديث pubspec.yaml
```bash
cd frontend
flutter pub add provider shared_preferences intl
```

### الخطوة 2: إنشاء المجلدات الجديدة
```bash
mkdir -p lib/src/models
mkdir -p lib/src/providers
```

### الخطوة 3: نسخ الملفات
- انسخ `lib/src/models/user_model.dart`
- انسخ `lib/src/providers/auth_provider.dart`
- حدّث `lib/src/app.dart`
- حدّث `lib/src/screens/home_screen.dart`

### الخطوة 4: تشغيل التطبيق
```bash
flutter run
```

---

## 🎯 النتيجة المتوقعة

بعد استكمال المرحلة الأولى والثانية:
- ✅ شاشة تسجيل دخول كاملة
- ✅ شاشة رئيسية مع Dashboard
- ✅ Navigation Bar بـ 5 خيارات
- ✅ User Data Persistence
- ✅ Logout Functionality

---

## ⏭️ المراحل القادمة

### المرحلة الثالثة: إكمال الـ Screens (2-3 ساعات)
- تطوير GradesScreen
- تطوير AttendanceScreen
- تطوير FinanceScreen
- تطوير ProfileScreen

### المرحلة الرابعة: ربط البيانات من Backend (2-3 ساعات)
- جلب البيانات من APIs
- معالجة الأخطاء
- إضافة Loading States
- Caching الممكن

### المرحلة الخامسة: التحسينات (1-2 ساعة)
- Offline Mode
- Local Notifications
- Dark Mode
- تعديل الحساب

---

## 💡 ملاحظات مهمة

1. **المسار الكامل**: `lib/src/`
2. **التوصيات**:
   - استخدم Provider لـ State Management
   - استخدم SharedPreferences للتخزين المحلي
   - معالجة الأخطاء بشكل صحيح
3. **الاختبار**: اختبر على أجهزة مختلفة

---

## 🚀 الخطوة التالية

**اختر من هنا:**
1. استكمل pubspec.yaml مع المكتبات الجديدة
2. أنشئ Models و Providers
3. حدّث App.dart و HomeScreen
4. شغّل التطبيق واختبر

**الوقت المتوقع**: 2-3 ساعات لاستكمال المرحلة الأولى والثانية

---

**استعد للبدء!** 🚀
