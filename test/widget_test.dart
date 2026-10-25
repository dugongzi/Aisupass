import 'package:Aisupass/core/routes/app_router.dart';
import 'package:Aisupass/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('启动后进入首页', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AiSuPassApp()));
    await tester.pumpAndSettle();

    // 标题栏、底栏、首页内容都会出现「首页」。
    expect(find.text('首页'), findsWidgets);
  });

  testWidgets('未知路径显示错误页', (WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AiSuPassApp(),
      ),
    );
    await tester.pumpAndSettle();

    container.read(appRouterProvider).go('/not-exist');
    await tester.pumpAndSettle();

    expect(find.text('页面不存在'), findsOneWidget);
  });
}
