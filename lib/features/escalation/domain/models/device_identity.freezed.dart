// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_identity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceIdentity {

/// 机型关键词拼接串，已小写、去重，如 `vivo iqoo 13 v2463a`。
 String get identityText;/// 完整内核串，如 `6.6.57-android14-11-g1a2b3c4d5e6f`。
 String get kernelRelease;/// 内核版本号，取 [kernelRelease] 第一个 `-` 之前的部分。
 String get kernelVersion;/// 内核 commit 短哈希；取不到时为空串。
 String get kernelCommit;/// 厂商，如 `vivo` / `Xiaomi`。
 String get manufacturer;/// 出厂型号代码，如 `V2463A`。
 String get model;/// 系统页大小（字节）。
 int get pageSize;
/// Create a copy of DeviceIdentity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceIdentityCopyWith<DeviceIdentity> get copyWith => _$DeviceIdentityCopyWithImpl<DeviceIdentity>(this as DeviceIdentity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceIdentity&&(identical(other.identityText, identityText) || other.identityText == identityText)&&(identical(other.kernelRelease, kernelRelease) || other.kernelRelease == kernelRelease)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&(identical(other.kernelCommit, kernelCommit) || other.kernelCommit == kernelCommit)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,identityText,kernelRelease,kernelVersion,kernelCommit,manufacturer,model,pageSize);

@override
String toString() {
  return 'DeviceIdentity(identityText: $identityText, kernelRelease: $kernelRelease, kernelVersion: $kernelVersion, kernelCommit: $kernelCommit, manufacturer: $manufacturer, model: $model, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $DeviceIdentityCopyWith<$Res>  {
  factory $DeviceIdentityCopyWith(DeviceIdentity value, $Res Function(DeviceIdentity) _then) = _$DeviceIdentityCopyWithImpl;
@useResult
$Res call({
 String identityText, String kernelRelease, String kernelVersion, String kernelCommit, String manufacturer, String model, int pageSize
});




}
/// @nodoc
class _$DeviceIdentityCopyWithImpl<$Res>
    implements $DeviceIdentityCopyWith<$Res> {
  _$DeviceIdentityCopyWithImpl(this._self, this._then);

  final DeviceIdentity _self;
  final $Res Function(DeviceIdentity) _then;

/// Create a copy of DeviceIdentity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identityText = null,Object? kernelRelease = null,Object? kernelVersion = null,Object? kernelCommit = null,Object? manufacturer = null,Object? model = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
identityText: null == identityText ? _self.identityText : identityText // ignore: cast_nullable_to_non_nullable
as String,kernelRelease: null == kernelRelease ? _self.kernelRelease : kernelRelease // ignore: cast_nullable_to_non_nullable
as String,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,kernelCommit: null == kernelCommit ? _self.kernelCommit : kernelCommit // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceIdentity].
extension DeviceIdentityPatterns on DeviceIdentity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceIdentity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceIdentity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceIdentity value)  $default,){
final _that = this;
switch (_that) {
case _DeviceIdentity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceIdentity value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceIdentity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String identityText,  String kernelRelease,  String kernelVersion,  String kernelCommit,  String manufacturer,  String model,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceIdentity() when $default != null:
return $default(_that.identityText,_that.kernelRelease,_that.kernelVersion,_that.kernelCommit,_that.manufacturer,_that.model,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String identityText,  String kernelRelease,  String kernelVersion,  String kernelCommit,  String manufacturer,  String model,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _DeviceIdentity():
return $default(_that.identityText,_that.kernelRelease,_that.kernelVersion,_that.kernelCommit,_that.manufacturer,_that.model,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String identityText,  String kernelRelease,  String kernelVersion,  String kernelCommit,  String manufacturer,  String model,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _DeviceIdentity() when $default != null:
return $default(_that.identityText,_that.kernelRelease,_that.kernelVersion,_that.kernelCommit,_that.manufacturer,_that.model,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceIdentity extends DeviceIdentity {
  const _DeviceIdentity({required this.identityText, required this.kernelRelease, required this.kernelVersion, required this.kernelCommit, required this.manufacturer, required this.model, required this.pageSize}): super._();
  

/// 机型关键词拼接串，已小写、去重，如 `vivo iqoo 13 v2463a`。
@override final  String identityText;
/// 完整内核串，如 `6.6.57-android14-11-g1a2b3c4d5e6f`。
@override final  String kernelRelease;
/// 内核版本号，取 [kernelRelease] 第一个 `-` 之前的部分。
@override final  String kernelVersion;
/// 内核 commit 短哈希；取不到时为空串。
@override final  String kernelCommit;
/// 厂商，如 `vivo` / `Xiaomi`。
@override final  String manufacturer;
/// 出厂型号代码，如 `V2463A`。
@override final  String model;
/// 系统页大小（字节）。
@override final  int pageSize;

/// Create a copy of DeviceIdentity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceIdentityCopyWith<_DeviceIdentity> get copyWith => __$DeviceIdentityCopyWithImpl<_DeviceIdentity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceIdentity&&(identical(other.identityText, identityText) || other.identityText == identityText)&&(identical(other.kernelRelease, kernelRelease) || other.kernelRelease == kernelRelease)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&(identical(other.kernelCommit, kernelCommit) || other.kernelCommit == kernelCommit)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode => Object.hash(runtimeType,identityText,kernelRelease,kernelVersion,kernelCommit,manufacturer,model,pageSize);

@override
String toString() {
  return 'DeviceIdentity(identityText: $identityText, kernelRelease: $kernelRelease, kernelVersion: $kernelVersion, kernelCommit: $kernelCommit, manufacturer: $manufacturer, model: $model, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$DeviceIdentityCopyWith<$Res> implements $DeviceIdentityCopyWith<$Res> {
  factory _$DeviceIdentityCopyWith(_DeviceIdentity value, $Res Function(_DeviceIdentity) _then) = __$DeviceIdentityCopyWithImpl;
@override @useResult
$Res call({
 String identityText, String kernelRelease, String kernelVersion, String kernelCommit, String manufacturer, String model, int pageSize
});




}
/// @nodoc
class __$DeviceIdentityCopyWithImpl<$Res>
    implements _$DeviceIdentityCopyWith<$Res> {
  __$DeviceIdentityCopyWithImpl(this._self, this._then);

  final _DeviceIdentity _self;
  final $Res Function(_DeviceIdentity) _then;

/// Create a copy of DeviceIdentity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identityText = null,Object? kernelRelease = null,Object? kernelVersion = null,Object? kernelCommit = null,Object? manufacturer = null,Object? model = null,Object? pageSize = null,}) {
  return _then(_DeviceIdentity(
identityText: null == identityText ? _self.identityText : identityText // ignore: cast_nullable_to_non_nullable
as String,kernelRelease: null == kernelRelease ? _self.kernelRelease : kernelRelease // ignore: cast_nullable_to_non_nullable
as String,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,kernelCommit: null == kernelCommit ? _self.kernelCommit : kernelCommit // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
