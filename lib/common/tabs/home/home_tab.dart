import 'package:Aisupass/common/widgets/app_ai_activation_card.dart';
import 'package:Aisupass/common/widgets/app_brand_title.dart';
import 'package:Aisupass/common/widgets/app_device_info_card.dart';
import 'package:Aisupass/common/widgets/app_system_status_cards.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 移动端首页内容。
///
/// 标题栏与底栏由 `MainPage` 提供，这里不要自带 Scaffold。
/// AI 激活状态来自当前配置的真实连通性检测。
class HomeTab extends HookConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> aiStatusAsync = ref.watch(aiStatusProvider);

    return ListView(
      // 底部留白，避免最后一项被悬浮底栏遮住。
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h),
      children: <Widget>[
        // 页面内的品牌标题，位于激活卡片上方。
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 8, 10, 12),
          child: AppBrandTitle(highlighted: true),
        ),
        AppAiActivationCard(
          isActivated: aiStatusAsync.value ?? false,
          // 首次没有结果才降级为检测中，刷新时保留上一次的状态。
          isLoading: !aiStatusAsync.hasValue,
        ),
        SizedBox(height: 12.h),
        const AppSystemStatusCards(),
        SizedBox(height: 16.h),
        const AppDeviceInfoCard(),
      ],
    );
  }
}
