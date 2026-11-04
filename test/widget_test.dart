import 'package:Aisupass/core/routes/app_router.dart';
import 'package:Aisupass/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 首页里有常驻动画（滚动指示器、光标闪烁等），`pumpAndSettle` 永远等不到
/// 「没有待调度帧」，因此这里只推进固定时长，不用 `pumpAndSettle`。
Future<void> _settleFirstFrame(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('启动后进入首页', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AiSuPassApp()));
    await _settleFirstFrame(tester);

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
    await _settleFirstFrame(tester);

    container.read(appRouterProvider).go('/not-exist');
    await _settleFirstFrame(tester);

    expect(find.text('页面不存在'), findsOneWidget);
  });
}
