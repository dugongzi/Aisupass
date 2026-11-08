import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 弹出载荷清单，返回用户点中的那一份；直接关掉则是 `null`。
///
/// 清单有一百多条，铺在页面里会把终端挤走，所以收进弹窗按需打开。
Future<Payload?> showPayloadCatalogDialog(BuildContext context) =>
    showDialog<Payload>(
      context: context,
      builder: (BuildContext context) => const PayloadCatalogDialog(),
    );

/// 载荷清单弹窗：把包内 catalog 的全部条目摊开，带搜索，点一条就选中。
///
/// 选中只是「挑出哪一份」，真跑之前还要走二次确认。
class PayloadCatalogDialog extends HookConsumerWidget {
  const PayloadCatalogDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<List<Payload>> catalog = ref.watch(payloadsProvider);

    final TextEditingController search = useTextEditingController();
    useEffect(() => search.dispose, <Object?>[search]);

    final ValueNotifier<String> keywordInput = useState<String>('');
    final String keyword = keywordInput.value.trim().toLowerCase();

    // 过滤放在 build 顶层：头部要报「筛完还剩多少条」。
    final List<Payload> all = catalog.value ?? const <Payload>[];
    final List<Payload> shown = keyword.isEmpty
        ? all
        : all
              .where((Payload payload) => _matches(payload, keyword))
              .toList(growable: false);

    return Dialog(
      backgroundColor: scheme.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 48.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      // 高度封顶在屏幕里，条数再多也只是列表内部滚。
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.78,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _CatalogHeader(
              title: l10n.escalationPayloadCatalogTitle,
              // 条数要等读完 catalog 才有，没读完就不占位。
              subtitle: catalog.hasValue
                  ? l10n.escalationPayloadCatalogCount(shown.length)
                  : null,
              onClose: () => Navigator.of(context).pop(),
            ),
            _SearchField(
              controller: search,
              hint: l10n.escalationPayloadCatalogSearch,
              onChanged: (String text) => keywordInput.value = text,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: scheme.outline.withValues(alpha: 0.24),
            ),
            Flexible(
              child: catalog.when(
                loading: () => SizedBox(height: 200.h, child: const Loading()),
                error: (Object error, StackTrace stackTrace) => SizedBox(
                  height: 220.h,
                  child: RefError(
                    onRetry: () => ref.invalidate(payloadsProvider),
                  ),
                ),
                data: (List<Payload> payloads) {
                  if (payloads.isEmpty) {
                    return _CatalogEmpty(
                      icon: Icons.inventory_2_outlined,
                      message: l10n.escalationPayloadCatalogEmpty,
                    );
                  }
                  if (shown.isEmpty) {
                    return _CatalogEmpty(
                      icon: Icons.search_off_rounded,
                      message: l10n.escalationPayloadCatalogNoMatch,
                    );
                  }
                  // shrinkWrap：命中少时弹窗跟着变矮，不要留一块空白。
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    itemCount: shown.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Payload payload = shown[index];
                      // 点一条就把它带回给页面，弹窗自己关掉。
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(payload),
                        child: _PayloadTile(payload: payload),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 搜索命中：展示名、厂商、文件名、内核版本、构建号都能搜到。
///
/// 文件名与构建号是排障时最常被拿来当关键词的两列。
bool _matches(Payload payload, String keyword) =>
    payload.displayName.toLowerCase().contains(keyword) ||
    payload.vendor.toLowerCase().contains(keyword) ||
    payload.library.toLowerCase().contains(keyword) ||
    payload.buildId.toLowerCase().contains(keyword) ||
    payload.kernelVersion.contains(keyword);

/// 弹窗头部：标题、条数、关闭键。
class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;

  /// 条数，还没加载出来时为 null。
  final String? subtitle;

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final String? count = subtitle;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 8.w, 10.h),
      child: Row(
        children: <Widget>[
          Icon(Icons.inventory_2_outlined, size: 18.sp, color: scheme.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                if (count != null) ...<Widget>[
                  SizedBox(height: 3.h),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: Icon(
              Icons.close_rounded,
              size: 20.sp,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// 搜索框：一百多条靠滚动找太慢。
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: TextStyle(fontSize: 13.sp, color: scheme.onSurface),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 18.sp,
            color: scheme.onSurfaceVariant,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 36.w,
            minHeight: 36.h,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (BuildContext context, TextEditingValue value, _) =>
                value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).deleteButtonTooltip,
                    icon: Icon(
                      Icons.clear_rounded,
                      size: 16.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 36.w,
            minHeight: 36.h,
          ),
          filled: true,
          fillColor: isDark
              ? scheme.onSurface.withValues(alpha: 0.04)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: scheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

/// 一条载荷：展示名 + 厂商与文件名，右侧挂内核标记。
class _PayloadTile extends StatelessWidget {
  const _PayloadTile({required this.payload});

  final Payload payload;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    // 内核信息一条不落：已知就写出版本号，未知/不限用文字说明。
    final String kernelLabel = payload.kernelUnknown
        ? l10n.escalationPayloadKernelUnknown
        : payload.kernelAgnostic
        ? l10n.escalationPayloadKernelAgnostic
        : payload.kernelVersion;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  payload.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                // 等宽字体：文件名里的下划线和数字对齐了才扫得快。
                Text(
                  '${payload.vendor} · ${payload.library}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.code,
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          // 内核版本是这个清单最重要的筛选依据，所以固定占一个位置。
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              kernelLabel,
              style: TextStyle(
                fontFamily: AppFonts.code,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: scheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 空态：清单本身为空，或搜索没有命中。
class _CatalogEmpty extends StatelessWidget {
  const _CatalogEmpty({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    return SizedBox(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 38.sp,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              style: TextStyle(fontSize: 13.sp, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
