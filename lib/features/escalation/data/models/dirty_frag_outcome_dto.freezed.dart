// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dirty_frag_outcome_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DirtyFragOutcomeDto {

 String get sessionId; String get output; int get exitCode; int get durationMs; bool get timedOut; String get resolvedVrOffset;/// 原生侧异常类名；空串表示无异常。
 String get failure;/// 终局分类。默认 [DirtyFragKind.running]，由仓储实现覆盖。
 DirtyFragKind get kind;/// 累积输出。中间块为空串，终局块由仓储实现填入。
 String get log;/// 受理失败原因码；受理成功时为空串。
 String get reason;
/// Create a copy of DirtyFragOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirtyFragOutcomeDtoCopyWith<DirtyFragOutcomeDto> get copyWith => _$DirtyFragOutcomeDtoCopyWithImpl<DirtyFragOutcomeDto>(this as DirtyFragOutcomeDto, _$identity);

  /// Serializes this DirtyFragOutcomeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirtyFragOutcomeDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.resolvedVrOffset, resolvedVrOffset) || other.resolvedVrOffset == resolvedVrOffset)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.log, log) || other.log == log)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,output,exitCode,durationMs,timedOut,resolvedVrOffset,failure,kind,log,reason);

@override
String toString() {
  return 'DirtyFragOutcomeDto(sessionId: $sessionId, output: $output, exitCode: $exitCode, durationMs: $durationMs, timedOut: $timedOut, resolvedVrOffset: $resolvedVrOffset, failure: $failure, kind: $kind, log: $log, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $DirtyFragOutcomeDtoCopyWith<$Res>  {
  factory $DirtyFragOutcomeDtoCopyWith(DirtyFragOutcomeDto value, $Res Function(DirtyFragOutcomeDto) _then) = _$DirtyFragOutcomeDtoCopyWithImpl;
@useResult
$Res call({
 String sessionId, String output, int exitCode, int durationMs, bool timedOut, String resolvedVrOffset, String failure, DirtyFragKind kind, String log, String reason
});




}
/// @nodoc
class _$DirtyFragOutcomeDtoCopyWithImpl<$Res>
    implements $DirtyFragOutcomeDtoCopyWith<$Res> {
  _$DirtyFragOutcomeDtoCopyWithImpl(this._self, this._then);

  final DirtyFragOutcomeDto _self;
  final $Res Function(DirtyFragOutcomeDto) _then;

/// Create a copy of DirtyFragOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? output = null,Object? exitCode = null,Object? durationMs = null,Object? timedOut = null,Object? resolvedVrOffset = null,Object? failure = null,Object? kind = null,Object? log = null,Object? reason = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,resolvedVrOffset: null == resolvedVrOffset ? _self.resolvedVrOffset : resolvedVrOffset // ignore: cast_nullable_to_non_nullable
as String,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DirtyFragKind,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DirtyFragOutcomeDto].
extension DirtyFragOutcomeDtoPatterns on DirtyFragOutcomeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirtyFragOutcomeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirtyFragOutcomeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirtyFragOutcomeDto value)  $default,){
final _that = this;
switch (_that) {
case _DirtyFragOutcomeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirtyFragOutcomeDto value)?  $default,){
final _that = this;
switch (_that) {
case _DirtyFragOutcomeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String output,  int exitCode,  int durationMs,  bool timedOut,  String resolvedVrOffset,  String failure,  DirtyFragKind kind,  String log,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirtyFragOutcomeDto() when $default != null:
return $default(_that.sessionId,_that.output,_that.exitCode,_that.durationMs,_that.timedOut,_that.resolvedVrOffset,_that.failure,_that.kind,_that.log,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String output,  int exitCode,  int durationMs,  bool timedOut,  String resolvedVrOffset,  String failure,  DirtyFragKind kind,  String log,  String reason)  $default,) {final _that = this;
switch (_that) {
case _DirtyFragOutcomeDto():
return $default(_that.sessionId,_that.output,_that.exitCode,_that.durationMs,_that.timedOut,_that.resolvedVrOffset,_that.failure,_that.kind,_that.log,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String output,  int exitCode,  int durationMs,  bool timedOut,  String resolvedVrOffset,  String failure,  DirtyFragKind kind,  String log,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _DirtyFragOutcomeDto() when $default != null:
return $default(_that.sessionId,_that.output,_that.exitCode,_that.durationMs,_that.timedOut,_that.resolvedVrOffset,_that.failure,_that.kind,_that.log,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DirtyFragOutcomeDto extends DirtyFragOutcomeDto {
  const _DirtyFragOutcomeDto({this.sessionId = '', this.output = '', this.exitCode = -1, this.durationMs = 0, this.timedOut = false, this.resolvedVrOffset = '', this.failure = '', this.kind = DirtyFragKind.running, this.log = '', this.reason = ''}): super._();
  factory _DirtyFragOutcomeDto.fromJson(Map<String, dynamic> json) => _$DirtyFragOutcomeDtoFromJson(json);

@override@JsonKey() final  String sessionId;
@override@JsonKey() final  String output;
@override@JsonKey() final  int exitCode;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  bool timedOut;
@override@JsonKey() final  String resolvedVrOffset;
/// 原生侧异常类名；空串表示无异常。
@override@JsonKey() final  String failure;
/// 终局分类。默认 [DirtyFragKind.running]，由仓储实现覆盖。
@override@JsonKey() final  DirtyFragKind kind;
/// 累积输出。中间块为空串，终局块由仓储实现填入。
@override@JsonKey() final  String log;
/// 受理失败原因码；受理成功时为空串。
@override@JsonKey() final  String reason;

/// Create a copy of DirtyFragOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirtyFragOutcomeDtoCopyWith<_DirtyFragOutcomeDto> get copyWith => __$DirtyFragOutcomeDtoCopyWithImpl<_DirtyFragOutcomeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DirtyFragOutcomeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirtyFragOutcomeDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.resolvedVrOffset, resolvedVrOffset) || other.resolvedVrOffset == resolvedVrOffset)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.log, log) || other.log == log)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,output,exitCode,durationMs,timedOut,resolvedVrOffset,failure,kind,log,reason);

@override
String toString() {
  return 'DirtyFragOutcomeDto(sessionId: $sessionId, output: $output, exitCode: $exitCode, durationMs: $durationMs, timedOut: $timedOut, resolvedVrOffset: $resolvedVrOffset, failure: $failure, kind: $kind, log: $log, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$DirtyFragOutcomeDtoCopyWith<$Res> implements $DirtyFragOutcomeDtoCopyWith<$Res> {
  factory _$DirtyFragOutcomeDtoCopyWith(_DirtyFragOutcomeDto value, $Res Function(_DirtyFragOutcomeDto) _then) = __$DirtyFragOutcomeDtoCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String output, int exitCode, int durationMs, bool timedOut, String resolvedVrOffset, String failure, DirtyFragKind kind, String log, String reason
});




}
/// @nodoc
class __$DirtyFragOutcomeDtoCopyWithImpl<$Res>
    implements _$DirtyFragOutcomeDtoCopyWith<$Res> {
  __$DirtyFragOutcomeDtoCopyWithImpl(this._self, this._then);

  final _DirtyFragOutcomeDto _self;
  final $Res Function(_DirtyFragOutcomeDto) _then;

/// Create a copy of DirtyFragOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? output = null,Object? exitCode = null,Object? durationMs = null,Object? timedOut = null,Object? resolvedVrOffset = null,Object? failure = null,Object? kind = null,Object? log = null,Object? reason = null,}) {
  return _then(_DirtyFragOutcomeDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,resolvedVrOffset: null == resolvedVrOffset ? _self.resolvedVrOffset : resolvedVrOffset // ignore: cast_nullable_to_non_nullable
as String,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DirtyFragKind,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
