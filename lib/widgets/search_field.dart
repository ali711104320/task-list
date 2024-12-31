import 'package:flutter/material.dart';
import 'package:todo_list/utils/colors.dart'; // تأكد من استيراد ملف الألوان

class SearchField extends StatelessWidget {
  final TextEditingController controller;

  SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 40, // تحديد ارتفاع الحقل ليكون أصغر
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 14), // تقليل حجم النص داخل الحقل
          decoration: InputDecoration(
            hintText: 'research...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary, // استخدام اللون الثانوي للنص
              fontSize: 14, // تقليل حجم النص المساعد
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.borderColor, // استخدام اللون المخصص للحدود
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.favoriteColor, // تغيير اللون عند التركيز
                width: 1.5,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.secondaryColor, // استخدام اللون الثانوي للأيقونة
              size: 20, // تصغير حجم الأيقونة
            ),
          ),
        ),
      ),
    );
  }
}
