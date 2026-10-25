import 'package:Aisupass/common/widgets/app_select.dart';
import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/locale_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 语言名称一律用该语言自身书写，不随界面语言翻译。
///
/// 例如界面是英文时，中文选项仍显示「中文」，而不是 "Chinese"。
const String _zhLabel = '中文';
const String _enLabel = 'English';

/// 语言设置项，供移动端与桌面端设置页共用。
///
/// 左侧图标胶囊 + 标题；移动端右侧用分段按钮，桌面端换成下拉框，
/// 与桌面应用的控件习惯保持一致。
class AppLanguageSwitch extends HookConsumerWidget {
  const AppLanguageSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeProvider);

    final Widget control = isDesktopPlatform
        ? AppSelect<String>(
            value: locale.languageCode,
            items: const <AppSelectItem<String>>[
              AppSelectItem<String>(value: 'zh', label: _zhLabel),
              AppSelectItem<String>(value: 'en', label: _enLabel),
            ],
            onChanged: (String value) =>
                ref.read(localeProvider.notifier).setLanguage(value),
          )
        : SegmentedButton<String>(
            segments: <ButtonSegment<String>>[
              ButtonSegment<String>(value: 'zh', label: const Text(_zhLabel)),
              ButtonSegment<String>(value: 'en', label: const Text(_enLabel)),
            ],
            selected: <String>{locale.languageCode},
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              textStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            onSelectionChanged: (Set<String> selection) =>
                ref.read(localeProvider.notifier).setLanguage(selection.first),
          );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: <Widget>[
          const AppSettingIcon(icon: Icons.translate_rounded),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              context.l10n.languageTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          control,
        ],
      ),
    );
  }
}
