// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dirty_frag_outcome.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DirtyFragOutcome {

/// 终局分类；[DirtyFragKind.running] 表示还有后续块。
 DirtyFragKind get kind;/// 会话标识；受理失败时为空串。
 String get sessionId;/// 自上次块以来新增的输出（stdout 与 stderr 合并），直接写屏。
 String get output;/// 累积输出，只有终局块非空；判定依据就是它。
 String get log;/// 退出码；`-1` 表示没取到。
///
/// 本链路里 `2` 在多数成功场景也会出现，不能单看退出码下结论。
 int get exitCode;/// 从受理到终局的耗时（毫秒）。
 int get durationMs;/// 是否因本侧取消而强制结束。
 bool get timedOut;/// `--vr-auto` 解析出的偏移（十进制字符串）；未解析出为空串。
 String get resolvedVrOffset;/// 受理失败原因码；受理成功时为空串。
 String get reason;
/// Create a copy of DirtyFragOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirtyFragOutcomeCopyWith<DirtyFragOutcome> get copyWith => _$DirtyFragOutcomeCopyWithImpl<DirtyFragOutcome>(this as DirtyFragOutcome, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirtyFragOutcome&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.log, log) || other.log == log)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.resolvedVrOffset, resolvedVrOffset) || other.resolvedVrOffset == resolvedVrOffset)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,kind,sessionId,output,log,exitCode,durationMs,timedOut,resolvedVrOffset,reason);

@override
String toString() {
  return 'DirtyFragOutcome(kind: $kind, sessionId: $sessionId, output: $output, log: $log, exitCode: $exitCode, durationMs: $durationMs, timedOut: $timedOut, resolvedVrOffset: $resolvedVrOffset, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $DirtyFragOutcomeCopyWith<$Res>  {
  factory $DirtyFragOutcomeCopyWith(DirtyFragOutcome value, $Res Function(DirtyFragOutcome) _then) = _$DirtyFragOutcomeCopyWithImpl;
@useResult
$Res call({
 DirtyFragKind kind, String sessionId, String output, String log, int exitCode, int durationMs, bool timedOut, String resolvedVrOffset, String reason
});




}
/// @nodoc
class _$DirtyFragOutcomeCopyWithImpl<$Res>
    implements $DirtyFragOutcomeCopyWith<$Res> {
  _$DirtyFragOutcomeCopyWithImpl(this._self, this._then);

  final DirtyFragOutcome _self;
  final $Res Function(DirtyFragOutcome) _then;

/// Create a copy of DirtyFragOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? sessionId = null,Object? output = null,Object? log = null,Object? exitCode = null,Object? durationMs = null,Object? timedOut = null,Object? resolvedVrOffset = null,Object? reason = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DirtyFragKind,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,resolvedVrOffset: null == resolvedVrOffset ? _self.resolvedVrOffset : resolvedVrOffset // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DirtyFragOutcome].
extension DirtyFragOutcomePatterns on DirtyFragOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirtyFragOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirtyFragOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirtyFragOutcome value)  $default,){
final _that = this;
switch (_that) {
case _DirtyFragOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirtyFragOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _DirtyFragOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DirtyFragKind kind,  String sessionId,  String output,  String log,  int exitCode,  int durationMs,  bool timedOut,  String resolvedVrOffset,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirtyFragOutcome() when $default != null:
return $default(_that.kind,_that.sessionId,_that.output,_that.log,_that.exitCode,_that.durationMs,_that.timedOut,_that.resolvedVrOffset,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DirtyFragKind kind,  String sessionId,  String output,  String log,  int exitCode,  int durationMs,  bool timedOut,  String resolvedVrOffset,  String reason)  $default,) {final _that = this;
switch (_that) {
case _DirtyFragOutcome():
return $default(_that.kind,_that.sessionId,_that.output,_that.log,_that.exitCode,_that.durationMs,_that.timedOut,_that.resolvedVrOffset,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DirtyFragKind kind,  String sessionId,  String output,  String log,  int exitCode,  int durationMs,  bool timedOut,  String resolvedVrOffset,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _DirtyFragOutcome() when $default != null:
return $default(_that.kind,_that.sessionId,_that.output,_that.log,_that.exitCode,_that.durationMs,_that.timedOut,_that.resolvedVrOffset,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _DirtyFragOutcome extends DirtyFragOutcome {
  const _DirtyFragOutcome({required this.kind, required this.sessionId, required this.output, required this.log, required this.exitCode, required this.durationMs, required this.timedOut, required this.resolvedVrOffset, required this.reason}): super._();
  

/// 终局分类；[DirtyFragKind.running] 表示还有后续块。
@override final  DirtyFragKind kind;
/// 会话标识；受理失败时为空串。
@override final  String sessionId;
/// 自上次块以来新增的输出（stdout 与 stderr 合并），直接写屏。
@override final  String output;
/// 累积输出，只有终局块非空；判定依据就是它。
@override final  String log;
/// 退出码；`-1` 表示没取到。
///
/// 本链路里 `2` 在多数成功场景也会出现，不能单看退出码下结论。
@override final  int exitCode;
/// 从受理到终局的耗时（毫秒）。
@override final  int durationMs;
/// 是否因本侧取消而强制结束。
@override final  bool timedOut;
/// `--vr-auto` 解析出的偏移（十进制字符串）；未解析出为空串。
@override final  String resolvedVrOffset;
/// 受理失败原因码；受理成功时为空串。
@override final  String reason;

/// Create a copy of DirtyFragOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirtyFragOutcomeCopyWith<_DirtyFragOutcome> get copyWith => __$DirtyFragOutcomeCopyWithImpl<_DirtyFragOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirtyFragOutcome&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.log, log) || other.log == log)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.resolvedVrOffset, resolvedVrOffset) || other.resolvedVrOffset == resolvedVrOffset)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,kind,sessionId,output,log,exitCode,durationMs,timedOut,resolvedVrOffset,reason);

@override
String toString() {
  return 'DirtyFragOutcome(kind: $kind, sessionId: $sessionId, output: $output, log: $log, exitCode: $exitCode, durationMs: $durationMs, timedOut: $timedOut, resolvedVrOffset: $resolvedVrOffset, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$DirtyFragOutcomeCopyWith<$Res> implements $DirtyFragOutcomeCopyWith<$Res> {
  factory _$DirtyFragOutcomeCopyWith(_DirtyFragOutcome value, $Res Function(_DirtyFragOutcome) _then) = __$DirtyFragOutcomeCopyWithImpl;
@override @useResult
$Res call({
 DirtyFragKind kind, String sessionId, String output, String log, int exitCode, int durationMs, bool timedOut, String resolvedVrOffset, String reason
});




}
/// @nodoc
class __$DirtyFragOutcomeCopyWithImpl<$Res>
    implements _$DirtyFragOutcomeCopyWith<$Res> {
  __$DirtyFragOutcomeCopyWithImpl(this._self, this._then);

  final _DirtyFragOutcome _self;
  final $Res Function(_DirtyFragOutcome) _then;

/// Create a copy of DirtyFragOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? sessionId = null,Object? output = null,Object? log = null,Object? exitCode = null,Object? durationMs = null,Object? timedOut = null,Object? resolvedVrOffset = null,Object? reason = null,}) {
  return _then(_DirtyFragOutcome(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DirtyFragKind,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,resolvedVrOffset: null == resolvedVrOffset ? _self.resolvedVrOffset : resolvedVrOffset // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
