// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_run_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EscalationRunResult {

/// 是否判定为提权成功（载荷日志标记通过，且 `su -c id` 确认为 uid 0）。
 bool get success;/// 命令退出码；`-1` 表示命令没跑起来，或退出码文件没读到。
///
/// 提权链路是「后台起 + 轮询日志」，设备端进程不在前台、回收不到返回值，
/// 退出码由启动脚本在助手退出后写进 `exploit.rc`，收日志时一并读回。
/// 也就是说这里可能出现任意非 0 值，不再只有 0 / -1 两档。
/// **判断成败只看 [success]**。
 int get exitCode;/// 标准输出。
 String get stdout;/// 标准错误。
 String get stderr;/// 耗时（毫秒）。
 int get durationMs;/// 是否因停滞或超时被掐断。
 bool get timedOut;
/// Create a copy of EscalationRunResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationRunResultCopyWith<EscalationRunResult> get copyWith => _$EscalationRunResultCopyWithImpl<EscalationRunResult>(this as EscalationRunResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationRunResult&&(identical(other.success, success) || other.success == success)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.stdout, stdout) || other.stdout == stdout)&&(identical(other.stderr, stderr) || other.stderr == stderr)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut));
}


@override
int get hashCode => Object.hash(runtimeType,success,exitCode,stdout,stderr,durationMs,timedOut);

@override
String toString() {
  return 'EscalationRunResult(success: $success, exitCode: $exitCode, stdout: $stdout, stderr: $stderr, durationMs: $durationMs, timedOut: $timedOut)';
}


}

/// @nodoc
abstract mixin class $EscalationRunResultCopyWith<$Res>  {
  factory $EscalationRunResultCopyWith(EscalationRunResult value, $Res Function(EscalationRunResult) _then) = _$EscalationRunResultCopyWithImpl;
@useResult
$Res call({
 bool success, int exitCode, String stdout, String stderr, int durationMs, bool timedOut
});




}
/// @nodoc
class _$EscalationRunResultCopyWithImpl<$Res>
    implements $EscalationRunResultCopyWith<$Res> {
  _$EscalationRunResultCopyWithImpl(this._self, this._then);

  final EscalationRunResult _self;
  final $Res Function(EscalationRunResult) _then;

/// Create a copy of EscalationRunResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? exitCode = null,Object? stdout = null,Object? stderr = null,Object? durationMs = null,Object? timedOut = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,stdout: null == stdout ? _self.stdout : stdout // ignore: cast_nullable_to_non_nullable
as String,stderr: null == stderr ? _self.stderr : stderr // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EscalationRunResult].
extension EscalationRunResultPatterns on EscalationRunResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationRunResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationRunResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationRunResult value)  $default,){
final _that = this;
switch (_that) {
case _EscalationRunResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationRunResult value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationRunResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int exitCode,  String stdout,  String stderr,  int durationMs,  bool timedOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationRunResult() when $default != null:
return $default(_that.success,_that.exitCode,_that.stdout,_that.stderr,_that.durationMs,_that.timedOut);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int exitCode,  String stdout,  String stderr,  int durationMs,  bool timedOut)  $default,) {final _that = this;
switch (_that) {
case _EscalationRunResult():
return $default(_that.success,_that.exitCode,_that.stdout,_that.stderr,_that.durationMs,_that.timedOut);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int exitCode,  String stdout,  String stderr,  int durationMs,  bool timedOut)?  $default,) {final _that = this;
switch (_that) {
case _EscalationRunResult() when $default != null:
return $default(_that.success,_that.exitCode,_that.stdout,_that.stderr,_that.durationMs,_that.timedOut);case _:
  return null;

}
}

}

/// @nodoc


class _EscalationRunResult extends EscalationRunResult {
  const _EscalationRunResult({required this.success, required this.exitCode, required this.stdout, required this.stderr, required this.durationMs, required this.timedOut}): super._();
  

/// 是否判定为提权成功（载荷日志标记通过，且 `su -c id` 确认为 uid 0）。
@override final  bool success;
/// 命令退出码；`-1` 表示命令没跑起来，或退出码文件没读到。
///
/// 提权链路是「后台起 + 轮询日志」，设备端进程不在前台、回收不到返回值，
/// 退出码由启动脚本在助手退出后写进 `exploit.rc`，收日志时一并读回。
/// 也就是说这里可能出现任意非 0 值，不再只有 0 / -1 两档。
/// **判断成败只看 [success]**。
@override final  int exitCode;
/// 标准输出。
@override final  String stdout;
/// 标准错误。
@override final  String stderr;
/// 耗时（毫秒）。
@override final  int durationMs;
/// 是否因停滞或超时被掐断。
@override final  bool timedOut;

/// Create a copy of EscalationRunResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationRunResultCopyWith<_EscalationRunResult> get copyWith => __$EscalationRunResultCopyWithImpl<_EscalationRunResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationRunResult&&(identical(other.success, success) || other.success == success)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.stdout, stdout) || other.stdout == stdout)&&(identical(other.stderr, stderr) || other.stderr == stderr)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut));
}


@override
int get hashCode => Object.hash(runtimeType,success,exitCode,stdout,stderr,durationMs,timedOut);

@override
String toString() {
  return 'EscalationRunResult(success: $success, exitCode: $exitCode, stdout: $stdout, stderr: $stderr, durationMs: $durationMs, timedOut: $timedOut)';
}


}

/// @nodoc
abstract mixin class _$EscalationRunResultCopyWith<$Res> implements $EscalationRunResultCopyWith<$Res> {
  factory _$EscalationRunResultCopyWith(_EscalationRunResult value, $Res Function(_EscalationRunResult) _then) = __$EscalationRunResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, int exitCode, String stdout, String stderr, int durationMs, bool timedOut
});




}
/// @nodoc
class __$EscalationRunResultCopyWithImpl<$Res>
    implements _$EscalationRunResultCopyWith<$Res> {
  __$EscalationRunResultCopyWithImpl(this._self, this._then);

  final _EscalationRunResult _self;
  final $Res Function(_EscalationRunResult) _then;

/// Create a copy of EscalationRunResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? exitCode = null,Object? stdout = null,Object? stderr = null,Object? durationMs = null,Object? timedOut = null,}) {
  return _then(_EscalationRunResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,stdout: null == stdout ? _self.stdout : stdout // ignore: cast_nullable_to_non_nullable
as String,stderr: null == stderr ? _self.stderr : stderr // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
