import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/main.dart'; // استيراد ملف main.dart

void main() {
  testWidgets('To-Do List app test', (WidgetTester tester) async {
    // بناء التطبيق وتحميله في الاختبار
    await tester.pumpWidget(MyApp());

    // التحقق من وجود العنوان
    expect(find.text('To-Do List'), findsOneWidget);

    // إدخال مهمة جديدة
    await tester.enterText(find.byType(TextField).first, 'Test Task');
    await tester.pump(); // تحديث واجهة المستخدم بعد إدخال النص

    await tester.tap(find.text('Addition task')); // الضغط على زر "إضافة مهمة"
    await tester.pumpAndSettle(); // الانتظار حتى استقرار واجهة المستخدم

    // التحقق من أن المهمة تمت إضافتها
    expect(find.text('Test Task'), findsOneWidget);

    // الضغط على أيقونة المفضلة
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle(); // الانتظار حتى استقرار واجهة المستخدم

    // التحقق من أن المهمة أصبحت مفضلة
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    // حذف المهمة
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
    await tester.pumpAndSettle(); // الانتظار حتى استقرار واجهة المستخدم

    // التحقق من أن المهمة حُذفت
    expect(find.text('Test Task'), findsNothing);
  });
}
