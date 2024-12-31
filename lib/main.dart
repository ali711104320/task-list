import 'package:flutter/material.dart';
import 'package:todo_list/utils/colors.dart';
import 'screens/splash_screen.dart'; // استيراد شاشة البداية
import 'services/database_helper.dart'; // استيراد قاعدة البيانات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initializeDatabase(); // تهيئة قاعدة البيانات
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        brightness: Brightness.light, // سمة الوضع الفاتح
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.buttonColor, // تخصيص شريط التطبيق
          iconTheme: IconThemeData(
              color: const Color.fromARGB(
                  255, 0, 0, 0)), // تخصيص أيقونات الشريط العلوي
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: AppColors.primaryColor,
        brightness: Brightness.dark, // سمة الوضع المظلم
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.disabledColor,
          iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      themeMode: ThemeMode.system, // التبديل التلقائي بين الوضعين
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // تعيين شاشة البداية
    );
  }
}
