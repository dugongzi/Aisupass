import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 一行表格数据。
@immutable
class AppDataRow {
  const AppDataRow({required this.label, required this.value});

  final String label;
  final String value;
}

/// 两列数据表：左侧字段名、右侧取值，行间细分隔线。
///
/// 用来渲染结构化的键值数据（设备基本信息、状态快照等），
/// 比等宽 JSON 更易读；[onCopy] 不为空时整行可点，通常用于复制该项。
class AppDataTable extends HookWidget {
  const AppDataTable({
    super.key,
    required this.rows,
    this.labelWidth,
    this.onCopy,
    this.showDivider = true,
  });

  final List<AppDataRow> rows;

  /// 字段列宽度；为空时按平台取默认值。
  final double? labelWidth;

  /// 点击某一行的回调，一般用于复制该行内容。
  final ValueChanged<AppDataRow>? onCopy;

  /// 是否在行间绘制分隔线。
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;

    if (rows.isEmpty) return const SizedBox.shrink();

    final double labelColumn = labelWidth ?? (isDesktop ? 108 : 96.w);
    final TextStyle labelStyle = TextStyle(
      fontSize: isDesktop ? 12 : 12.sp,
      height: 1.35,
      color: colors.onSurfaceVariant.withValues(alpha: 0.78),
    );
    final TextStyle valueStyle = TextStyle(
      fontSize: isDesktop ? 12.5 : 12.5.sp,
      height: 1.35,
      color: colors.onSurface.withValues(alpha: 0.9),
    );

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < rows.length; i += 1) {
      if (i > 0 && showDivider) {
        children.add(
          Divider(
            height: 1,
            thickness: 1,
            color: colors.outlineVariant.withValues(alpha: 0.4),
          ),
        );
      }
      children.add(
        _DataRowView(
          row: rows[i],
          labelWidth: labelColumn,
          labelStyle: labelStyle,
          valueStyle: valueStyle,
          onCopy: onCopy,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _DataRowView extends StatelessWidget {
  const _DataRowView({
    required this.row,
    required this.labelWidth,
    required this.labelStyle,
    required this.valueStyle,
    required this.onCopy,
  });

  final AppDataRow row;
  final double labelWidth;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final ValueChanged<AppDataRow>? onCopy;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;

    final Widget content = Padding(
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 6 : 6.h,
        horizontal: isDesktop ? 2 : 2.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: labelWidth,
            child: Text(
              row.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: labelStyle,
            ),
          ),
          SizedBox(width: isDesktop ? 12 : 12.w),
          Expanded(
            child: Text(row.value, style: valueStyle),
          ),
        ],
      ),
    );

    if (onCopy == null) return content;

    return InkWell(
      onTap: () => onCopy!(row),
      borderRadius: BorderRadius.circular(isDesktop ? 6 : 6.r),
      child: content,
    );
  }
}
