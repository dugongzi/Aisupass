// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'handoff_outcome.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HandoffOutcome {

/// 结果形态，UI 按它分支。
 HandoffKind get kind;/// 本次移交的目标管理器。
 RootManager get manager;/// 本次实际使用的 ksud 路径（脚本回显的那一行），只有 [HandoffKind.success]
/// 时可靠。
 String get ksudPath;/// 命令退出码；`-1` 表示命令没跑起来。
 int get exitCode;/// 命令两路输出的合并结果，原样给用户核对。
 String get output;/// 耗时（毫秒）。
 int get durationMs;/// 是否因超时被掐断。
 bool get timedOut;
/// Create a copy of HandoffOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandoffOutcomeCopyWith<HandoffOutcome> get copyWith => _$HandoffOutcomeCopyWithImpl<HandoffOutcome>(this as HandoffOutcome, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandoffOutcome&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.manager, manager) || other.manager == manager)&&(identical(other.ksudPath, ksudPath) || other.ksudPath == ksudPath)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.output, output) || other.output == output)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut));
}


@override
int get hashCode => Object.hash(runtimeType,kind,manager,ksudPath,exitCode,output,durationMs,timedOut);

@override
String toString() {
  return 'HandoffOutcome(kind: $kind, manager: $manager, ksudPath: $ksudPath, exitCode: $exitCode, output: $output, durationMs: $durationMs, timedOut: $timedOut)';
}


}

/// @nodoc
abstract mixin class $HandoffOutcomeCopyWith<$Res>  {
  factory $HandoffOutcomeCopyWith(HandoffOutcome value, $Res Function(HandoffOutcome) _then) = _$HandoffOutcomeCopyWithImpl;
@useResult
$Res call({
 HandoffKind kind, RootManager manager, String ksudPath, int exitCode, String output, int durationMs, bool timedOut
});


$RootManagerCopyWith<$Res> get manager;

}
/// @nodoc
class _$HandoffOutcomeCopyWithImpl<$Res>
    implements $HandoffOutcomeCopyWith<$Res> {
  _$HandoffOutcomeCopyWithImpl(this._self, this._then);

  final HandoffOutcome _self;
  final $Res Function(HandoffOutcome) _then;

/// Create a copy of HandoffOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? manager = null,Object? ksudPath = null,Object? exitCode = null,Object? output = null,Object? durationMs = null,Object? timedOut = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as HandoffKind,manager: null == manager ? _self.manager : manager // ignore: cast_nullable_to_non_nullable
as RootManager,ksudPath: null == ksudPath ? _self.ksudPath : ksudPath // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HandoffOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RootManagerCopyWith<$Res> get manager {
  
  return $RootManagerCopyWith<$Res>(_self.manager, (value) {
    return _then(_self.copyWith(manager: value));
  });
}
}


/// Adds pattern-matching-related methods to [HandoffOutcome].
extension HandoffOutcomePatterns on HandoffOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HandoffOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HandoffOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HandoffOutcome value)  $default,){
final _that = this;
switch (_that) {
case _HandoffOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HandoffOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _HandoffOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HandoffKind kind,  RootManager manager,  String ksudPath,  int exitCode,  String output,  int durationMs,  bool timedOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HandoffOutcome() when $default != null:
return $default(_that.kind,_that.manager,_that.ksudPath,_that.exitCode,_that.output,_that.durationMs,_that.timedOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HandoffKind kind,  RootManager manager,  String ksudPath,  int exitCode,  String output,  int durationMs,  bool timedOut)  $default,) {final _that = this;
switch (_that) {
case _HandoffOutcome():
return $default(_that.kind,_that.manager,_that.ksudPath,_that.exitCode,_that.output,_that.durationMs,_that.timedOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HandoffKind kind,  RootManager manager,  String ksudPath,  int exitCode,  String output,  int durationMs,  bool timedOut)?  $default,) {final _that = this;
switch (_that) {
case _HandoffOutcome() when $default != null:
return $default(_that.kind,_that.manager,_that.ksudPath,_that.exitCode,_that.output,_that.durationMs,_that.timedOut);case _:
  return null;

}
}

}

/// @nodoc


class _HandoffOutcome extends HandoffOutcome {
  const _HandoffOutcome({required this.kind, required this.manager, required this.ksudPath, required this.exitCode, required this.output, required this.durationMs, required this.timedOut}): super._();
  

/// 结果形态，UI 按它分支。
@override final  HandoffKind kind;
/// 本次移交的目标管理器。
@override final  RootManager manager;
/// 本次实际使用的 ksud 路径（脚本回显的那一行），只有 [HandoffKind.success]
/// 时可靠。
@override final  String ksudPath;
/// 命令退出码；`-1` 表示命令没跑起来。
@override final  int exitCode;
/// 命令两路输出的合并结果，原样给用户核对。
@override final  String output;
/// 耗时（毫秒）。
@override final  int durationMs;
/// 是否因超时被掐断。
@override final  bool timedOut;

/// Create a copy of HandoffOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HandoffOutcomeCopyWith<_HandoffOutcome> get copyWith => __$HandoffOutcomeCopyWithImpl<_HandoffOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HandoffOutcome&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.manager, manager) || other.manager == manager)&&(identical(other.ksudPath, ksudPath) || other.ksudPath == ksudPath)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.output, output) || other.output == output)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut));
}


@override
int get hashCode => Object.hash(runtimeType,kind,manager,ksudPath,exitCode,output,durationMs,timedOut);

@override
String toString() {
  return 'HandoffOutcome(kind: $kind, manager: $manager, ksudPath: $ksudPath, exitCode: $exitCode, output: $output, durationMs: $durationMs, timedOut: $timedOut)';
}


}

/// @nodoc
abstract mixin class _$HandoffOutcomeCopyWith<$Res> implements $HandoffOutcomeCopyWith<$Res> {
  factory _$HandoffOutcomeCopyWith(_HandoffOutcome value, $Res Function(_HandoffOutcome) _then) = __$HandoffOutcomeCopyWithImpl;
@override @useResult
$Res call({
 HandoffKind kind, RootManager manager, String ksudPath, int exitCode, String output, int durationMs, bool timedOut
});


@override $RootManagerCopyWith<$Res> get manager;

}
/// @nodoc
class __$HandoffOutcomeCopyWithImpl<$Res>
    implements _$HandoffOutcomeCopyWith<$Res> {
  __$HandoffOutcomeCopyWithImpl(this._self, this._then);

  final _HandoffOutcome _self;
  final $Res Function(_HandoffOutcome) _then;

/// Create a copy of HandoffOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? manager = null,Object? ksudPath = null,Object? exitCode = null,Object? output = null,Object? durationMs = null,Object? timedOut = null,}) {
  return _then(_HandoffOutcome(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as HandoffKind,manager: null == manager ? _self.manager : manager // ignore: cast_nullable_to_non_nullable
as RootManager,ksudPath: null == ksudPath ? _self.ksudPath : ksudPath // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HandoffOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RootManagerCopyWith<$Res> get manager {
  
  return $RootManagerCopyWith<$Res>(_self.manager, (value) {
    return _then(_self.copyWith(manager: value));
  });
}
}

// dart format on
