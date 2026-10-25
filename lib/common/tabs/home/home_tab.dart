import 'package:Aisupass/common/widgets/app_ai_activation_card.dart';
import 'package:Aisupass/common/widgets/app_brand_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 移动端首页内容。
///
/// 标题栏与底栏由 `MainPage` 提供，这里不要自带 Scaffold。
/// AI 配置功能尚未接入，激活状态暂时固定为未激活。
class HomeTab extends HookWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // 底部留白，避免最后一项被悬浮底栏遮住。
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h),
      children: const <Widget>[
        // 页面内的品牌标题，位于激活卡片上方。
        Padding(
          padding: EdgeInsets.fromLTRB(10, 8, 10, 12),
          child: AppBrandTitle(highlighted: true),
        ),
        AppAiActivationCard(isActivated: true),
      ],
    );
  }
}
