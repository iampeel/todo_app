// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/services/storage_service.dart';
import 'package:todo_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // SharedPreferences 초기화
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);

    // 앱 빌드
    await tester.pumpWidget(MyApp(storageService: storageService));

    // 'Todo App' 텍스트 찾기
    expect(find.text('Todo App'), findsOneWidget);
  });
}