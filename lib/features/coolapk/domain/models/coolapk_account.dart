import 'package:freezed_annotation/freezed_annotation.dart';

part 'coolapk_account.freezed.dart';

/// 当前登录的酷安账号。
///
/// 只作为「会话是否真的生效」的证据：能拿到 uid 才说明 Cookie 被服务端认可。
/// 游客态的 Cookie 里也有一份 SESSID，光看 Cookie 非空会把游客当登录。
@freezed
abstract class CoolapkAccount with _$CoolapkAccount {
  const CoolapkAccount._();

  const factory CoolapkAccount({
    /// 账号 id，空串即未取到。
    required String uid,

    /// 昵称。
    required String username,

    /// 头像地址，可能为空。
    required String userAvatar,
  }) = _CoolapkAccount;

  /// 服务端认了这个会话。
  bool get isValid => uid.isNotEmpty;
}
