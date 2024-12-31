import 'package:flutter/material.dart';
import 'todo_home_page.dart'; // تأكد من استيراد الصفحة.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // تحديد مدة الانتظار (5 ثوانٍ) ثم الانتقال إلى الصفحة التالية
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ToDoHomePage()), // التوجيه إلى ToDoHomePage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // يمكنك تغيير اللون حسب التصميم
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/images/logo1.gif'), // عرض الصورة المتحركة بدلاً من المؤشر
            SizedBox(height: 20),
            Text(
              "Loading...",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
