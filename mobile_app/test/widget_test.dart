import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo_mobile/main.dart';

void main() {
  testWidgets('shows the login screen first', (tester) async {
    await tester.pumpWidget(const SimpleTodoMobileApp());

    expect(find.text('登录'), findsOneWidget);
    expect(find.text('邮箱'), findsOneWidget);
    expect(find.text('还没有账号？创建账号'), findsOneWidget);
  });
}
