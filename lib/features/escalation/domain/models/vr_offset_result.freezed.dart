// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vr_offset_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VrOffsetResult {

/// 是否提取成功。
 bool get ok;/// `struct tracepoint` 里 `funcs` 的成员偏移；失败时为 `0`。
///
/// 成功时取值区间为 `1..256`，可直接喂给 `--vr-off`。
 int get member;/// 内核 release 串；未取到为空串。
 String get release;/// 失败原因；成功时为空串。
 String get error;
/// Create a copy of VrOffsetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VrOffsetResultCopyWith<VrOffsetResult> get copyWith => _$VrOffsetResultCopyWithImpl<VrOffsetResult>(this as VrOffsetResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VrOffsetResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.member, member) || other.member == member)&&(identical(other.release, release) || other.release == release)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,ok,member,release,error);

@override
String toString() {
  return 'VrOffsetResult(ok: $ok, member: $member, release: $release, error: $error)';
}


}

/// @nodoc
abstract mixin class $VrOffsetResultCopyWith<$Res>  {
  factory $VrOffsetResultCopyWith(VrOffsetResult value, $Res Function(VrOffsetResult) _then) = _$VrOffsetResultCopyWithImpl;
@useResult
$Res call({
 bool ok, int member, String release, String error
});




}
/// @nodoc
class _$VrOffsetResultCopyWithImpl<$Res>
    implements $VrOffsetResultCopyWith<$Res> {
  _$VrOffsetResultCopyWithImpl(this._self, this._then);

  final VrOffsetResult _self;
  final $Res Function(VrOffsetResult) _then;

/// Create a copy of VrOffsetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? member = null,Object? release = null,Object? error = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as int,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VrOffsetResult].
extension VrOffsetResultPatterns on VrOffsetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VrOffsetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VrOffsetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VrOffsetResult value)  $default,){
final _that = this;
switch (_that) {
case _VrOffsetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VrOffsetResult value)?  $default,){
final _that = this;
switch (_that) {
case _VrOffsetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  int member,  String release,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VrOffsetResult() when $default != null:
return $default(_that.ok,_that.member,_that.release,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  int member,  String release,  String error)  $default,) {final _that = this;
switch (_that) {
case _VrOffsetResult():
return $default(_that.ok,_that.member,_that.release,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  int member,  String release,  String error)?  $default,) {final _that = this;
switch (_that) {
case _VrOffsetResult() when $default != null:
return $default(_that.ok,_that.member,_that.release,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _VrOffsetResult extends VrOffsetResult {
  const _VrOffsetResult({required this.ok, required this.member, required this.release, required this.error}): super._();
  

/// 是否提取成功。
@override final  bool ok;
/// `struct tracepoint` 里 `funcs` 的成员偏移；失败时为 `0`。
///
/// 成功时取值区间为 `1..256`，可直接喂给 `--vr-off`。
@override final  int member;
/// 内核 release 串；未取到为空串。
@override final  String release;
/// 失败原因；成功时为空串。
@override final  String error;

/// Create a copy of VrOffsetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VrOffsetResultCopyWith<_VrOffsetResult> get copyWith => __$VrOffsetResultCopyWithImpl<_VrOffsetResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VrOffsetResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.member, member) || other.member == member)&&(identical(other.release, release) || other.release == release)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,ok,member,release,error);

@override
String toString() {
  return 'VrOffsetResult(ok: $ok, member: $member, release: $release, error: $error)';
}


}

/// @nodoc
abstract mixin class _$VrOffsetResultCopyWith<$Res> implements $VrOffsetResultCopyWith<$Res> {
  factory _$VrOffsetResultCopyWith(_VrOffsetResult value, $Res Function(_VrOffsetResult) _then) = __$VrOffsetResultCopyWithImpl;
@override @useResult
$Res call({
 bool ok, int member, String release, String error
});




}
/// @nodoc
class __$VrOffsetResultCopyWithImpl<$Res>
    implements _$VrOffsetResultCopyWith<$Res> {
  __$VrOffsetResultCopyWithImpl(this._self, this._then);

  final _VrOffsetResult _self;
  final $Res Function(_VrOffsetResult) _then;

/// Create a copy of VrOffsetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? member = null,Object? release = null,Object? error = null,}) {
  return _then(_VrOffsetResult(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as int,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
