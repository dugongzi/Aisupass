// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vr_derive_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VrDeriveProgress {

/// 阶段：0 下载，1 解包。
 int get phase;/// 本阶段已完成量。
 int get done;/// 本阶段总量；未知时为 `0`。
 int get total;
/// Create a copy of VrDeriveProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VrDeriveProgressCopyWith<VrDeriveProgress> get copyWith => _$VrDeriveProgressCopyWithImpl<VrDeriveProgress>(this as VrDeriveProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VrDeriveProgress&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,phase,done,total);

@override
String toString() {
  return 'VrDeriveProgress(phase: $phase, done: $done, total: $total)';
}


}

/// @nodoc
abstract mixin class $VrDeriveProgressCopyWith<$Res>  {
  factory $VrDeriveProgressCopyWith(VrDeriveProgress value, $Res Function(VrDeriveProgress) _then) = _$VrDeriveProgressCopyWithImpl;
@useResult
$Res call({
 int phase, int done, int total
});




}
/// @nodoc
class _$VrDeriveProgressCopyWithImpl<$Res>
    implements $VrDeriveProgressCopyWith<$Res> {
  _$VrDeriveProgressCopyWithImpl(this._self, this._then);

  final VrDeriveProgress _self;
  final $Res Function(VrDeriveProgress) _then;

/// Create a copy of VrDeriveProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? done = null,Object? total = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VrDeriveProgress].
extension VrDeriveProgressPatterns on VrDeriveProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VrDeriveProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VrDeriveProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VrDeriveProgress value)  $default,){
final _that = this;
switch (_that) {
case _VrDeriveProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VrDeriveProgress value)?  $default,){
final _that = this;
switch (_that) {
case _VrDeriveProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int phase,  int done,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VrDeriveProgress() when $default != null:
return $default(_that.phase,_that.done,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int phase,  int done,  int total)  $default,) {final _that = this;
switch (_that) {
case _VrDeriveProgress():
return $default(_that.phase,_that.done,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int phase,  int done,  int total)?  $default,) {final _that = this;
switch (_that) {
case _VrDeriveProgress() when $default != null:
return $default(_that.phase,_that.done,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _VrDeriveProgress extends VrDeriveProgress {
  const _VrDeriveProgress({required this.phase, required this.done, required this.total}): super._();
  

/// 阶段：0 下载，1 解包。
@override final  int phase;
/// 本阶段已完成量。
@override final  int done;
/// 本阶段总量；未知时为 `0`。
@override final  int total;

/// Create a copy of VrDeriveProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VrDeriveProgressCopyWith<_VrDeriveProgress> get copyWith => __$VrDeriveProgressCopyWithImpl<_VrDeriveProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VrDeriveProgress&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,phase,done,total);

@override
String toString() {
  return 'VrDeriveProgress(phase: $phase, done: $done, total: $total)';
}


}

/// @nodoc
abstract mixin class _$VrDeriveProgressCopyWith<$Res> implements $VrDeriveProgressCopyWith<$Res> {
  factory _$VrDeriveProgressCopyWith(_VrDeriveProgress value, $Res Function(_VrDeriveProgress) _then) = __$VrDeriveProgressCopyWithImpl;
@override @useResult
$Res call({
 int phase, int done, int total
});




}
/// @nodoc
class __$VrDeriveProgressCopyWithImpl<$Res>
    implements _$VrDeriveProgressCopyWith<$Res> {
  __$VrDeriveProgressCopyWithImpl(this._self, this._then);

  final _VrDeriveProgress _self;
  final $Res Function(_VrDeriveProgress) _then;

/// Create a copy of VrDeriveProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? done = null,Object? total = null,}) {
  return _then(_VrDeriveProgress(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
