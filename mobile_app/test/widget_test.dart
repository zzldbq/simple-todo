import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo_mobile/main.dart';

void main() {
  testWidgets('shows the first mobile todo screen', (tester) async {
    await tester.pumpWidget(const SimpleTodoMobileApp());

    expect(find.text('简单待办'), findsOneWidget);
    expect(find.text('我的任务'), findsOneWidget);
    expect(find.text('输入新任务...'), findsOneWidget);
  });
}
