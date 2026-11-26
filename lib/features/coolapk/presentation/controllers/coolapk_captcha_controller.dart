import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:Aisupass/features/coolapk/domain/enums/coolapk_captcha_status.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_auth_action_provider.dart';

/// 酷安人机验证页的编排：裁决脚本回传、把票据落盘。
///
/// 只做流程判定与存储，不接触 `BuildContext`、不弹提示：页面拿到
/// [CoolapkCaptchaStatus] 后自己决定文案与跳转。
class CoolapkCaptchaController {
  const CoolapkCaptchaController({required this._ref});

  final WidgetRef _ref;

  /// 脚本回传协议：`ready` 就绪、`verify:<票据>` 通过、`error:<内容>` 失败。
  static const String _verifyPrefix = 'verify:';
  static const String _errorPrefix = 'error:';

  /// 处理注入脚本回传的一条消息。
  ///
  /// 返回状态与失败原因原文；`verify:` 会顺带完成落盘。
  Future<({CoolapkCaptchaStatus status, String detail})> handle(
    String payload, {
    required String captchaId,
  }) async {
    if (payload == 'ready') {
      return (status: CoolapkCaptchaStatus.ready, detail: '');
    }
    if (payload.startsWith(_verifyPrefix)) {
      final String validate = payload.substring(_verifyPrefix.length);
      return save(validate: validate, captchaId: captchaId);
    }
    if (payload.startsWith(_errorPrefix)) {
      final String detail = payload.substring(_errorPrefix.length).trim();
      return (status: CoolapkCaptchaStatus.failed, detail: detail);
    }
    // 未知消息不改变界面状态，避免脚本新增字段时误报失败。
    return (status: CoolapkCaptchaStatus.ignored, detail: '');
  }

  /// 保存票据；失败时返回 [CoolapkCaptchaStatus.failed]。
  ///
  /// [captchaId] 必须跟着票据一起交出去：酷安只认
  /// `NEC:<captchaId 前 8 位>:<validate>` 这种格式的票据。
  Future<({CoolapkCaptchaStatus status, String detail})> save({
    required String validate,
    required String captchaId,
  }) async {
    if (validate.trim().isEmpty || captchaId.trim().isEmpty) {
      return (status: CoolapkCaptchaStatus.failed, detail: '');
    }
    try {
      await _ref
          .read(coolapkAuthActionsProvider)
          .saveCaptchaValidate(validate: validate, captchaId: captchaId);
      return (status: CoolapkCaptchaStatus.saved, detail: '');
    } catch (_) {
      return (status: CoolapkCaptchaStatus.failed, detail: '');
    }
  }
}
