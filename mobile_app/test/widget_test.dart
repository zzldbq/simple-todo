import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo_mobile/main.dart';

void main() {
  testWidgets('shows the login screen first', (tester) async {
    await tester.pumpWidget(const SimpleTodoMobileApp());

    expect(find.text('登录'), findsWidgets);
    expect(find.text('邮箱'), findsOneWidget);
    expect(find.text('还没有账号？创建账号'), findsOneWidget);
  });

  testWidgets('can add and delete a local task', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const MaterialApp(home: TaskHomePage()),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText), '买牛奶');
    await tester.tap(find.text('添加任务'));
    await tester.pump();

    expect(find.text('买牛奶'), findsOneWidget);

    await tester.tap(find.byTooltip('删除').first);
    await tester.pump();

    expect(find.text('买牛奶'), findsNothing);
  });
}
