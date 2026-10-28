// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_fingerprint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceFingerprint {

 int get androidSdk; String get abi; String get kernelVersion; bool get selinuxEnforcing; String get manufacturer; String get model; bool get isEmulator;
/// Create a copy of DeviceFingerprint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceFingerprintCopyWith<DeviceFingerprint> get copyWith => _$DeviceFingerprintCopyWithImpl<DeviceFingerprint>(this as DeviceFingerprint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceFingerprint&&(identical(other.androidSdk, androidSdk) || other.androidSdk == androidSdk)&&(identical(other.abi, abi) || other.abi == abi)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&(identical(other.selinuxEnforcing, selinuxEnforcing) || other.selinuxEnforcing == selinuxEnforcing)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.isEmulator, isEmulator) || other.isEmulator == isEmulator));
}


@override
int get hashCode => Object.hash(runtimeType,androidSdk,abi,kernelVersion,selinuxEnforcing,manufacturer,model,isEmulator);

@override
String toString() {
  return 'DeviceFingerprint(androidSdk: $androidSdk, abi: $abi, kernelVersion: $kernelVersion, selinuxEnforcing: $selinuxEnforcing, manufacturer: $manufacturer, model: $model, isEmulator: $isEmulator)';
}


}

/// @nodoc
abstract mixin class $DeviceFingerprintCopyWith<$Res>  {
  factory $DeviceFingerprintCopyWith(DeviceFingerprint value, $Res Function(DeviceFingerprint) _then) = _$DeviceFingerprintCopyWithImpl;
@useResult
$Res call({
 int androidSdk, String abi, String kernelVersion, bool selinuxEnforcing, String manufacturer, String model, bool isEmulator
});




}
/// @nodoc
class _$DeviceFingerprintCopyWithImpl<$Res>
    implements $DeviceFingerprintCopyWith<$Res> {
  _$DeviceFingerprintCopyWithImpl(this._self, this._then);

  final DeviceFingerprint _self;
  final $Res Function(DeviceFingerprint) _then;

/// Create a copy of DeviceFingerprint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? androidSdk = null,Object? abi = null,Object? kernelVersion = null,Object? selinuxEnforcing = null,Object? manufacturer = null,Object? model = null,Object? isEmulator = null,}) {
  return _then(_self.copyWith(
androidSdk: null == androidSdk ? _self.androidSdk : androidSdk // ignore: cast_nullable_to_non_nullable
as int,abi: null == abi ? _self.abi : abi // ignore: cast_nullable_to_non_nullable
as String,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,selinuxEnforcing: null == selinuxEnforcing ? _self.selinuxEnforcing : selinuxEnforcing // ignore: cast_nullable_to_non_nullable
as bool,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,isEmulator: null == isEmulator ? _self.isEmulator : isEmulator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceFingerprint].
extension DeviceFingerprintPatterns on DeviceFingerprint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceFingerprint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceFingerprint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceFingerprint value)  $default,){
final _that = this;
switch (_that) {
case _DeviceFingerprint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceFingerprint value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceFingerprint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int androidSdk,  String abi,  String kernelVersion,  bool selinuxEnforcing,  String manufacturer,  String model,  bool isEmulator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceFingerprint() when $default != null:
return $default(_that.androidSdk,_that.abi,_that.kernelVersion,_that.selinuxEnforcing,_that.manufacturer,_that.model,_that.isEmulator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int androidSdk,  String abi,  String kernelVersion,  bool selinuxEnforcing,  String manufacturer,  String model,  bool isEmulator)  $default,) {final _that = this;
switch (_that) {
case _DeviceFingerprint():
return $default(_that.androidSdk,_that.abi,_that.kernelVersion,_that.selinuxEnforcing,_that.manufacturer,_that.model,_that.isEmulator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int androidSdk,  String abi,  String kernelVersion,  bool selinuxEnforcing,  String manufacturer,  String model,  bool isEmulator)?  $default,) {final _that = this;
switch (_that) {
case _DeviceFingerprint() when $default != null:
return $default(_that.androidSdk,_that.abi,_that.kernelVersion,_that.selinuxEnforcing,_that.manufacturer,_that.model,_that.isEmulator);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceFingerprint extends DeviceFingerprint {
  const _DeviceFingerprint({required this.androidSdk, required this.abi, required this.kernelVersion, required this.selinuxEnforcing, required this.manufacturer, required this.model, required this.isEmulator}): super._();
  

@override final  int androidSdk;
@override final  String abi;
@override final  String kernelVersion;
@override final  bool selinuxEnforcing;
@override final  String manufacturer;
@override final  String model;
@override final  bool isEmulator;

/// Create a copy of DeviceFingerprint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceFingerprintCopyWith<_DeviceFingerprint> get copyWith => __$DeviceFingerprintCopyWithImpl<_DeviceFingerprint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceFingerprint&&(identical(other.androidSdk, androidSdk) || other.androidSdk == androidSdk)&&(identical(other.abi, abi) || other.abi == abi)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&(identical(other.selinuxEnforcing, selinuxEnforcing) || other.selinuxEnforcing == selinuxEnforcing)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.isEmulator, isEmulator) || other.isEmulator == isEmulator));
}


@override
int get hashCode => Object.hash(runtimeType,androidSdk,abi,kernelVersion,selinuxEnforcing,manufacturer,model,isEmulator);

@override
String toString() {
  return 'DeviceFingerprint(androidSdk: $androidSdk, abi: $abi, kernelVersion: $kernelVersion, selinuxEnforcing: $selinuxEnforcing, manufacturer: $manufacturer, model: $model, isEmulator: $isEmulator)';
}


}

/// @nodoc
abstract mixin class _$DeviceFingerprintCopyWith<$Res> implements $DeviceFingerprintCopyWith<$Res> {
  factory _$DeviceFingerprintCopyWith(_DeviceFingerprint value, $Res Function(_DeviceFingerprint) _then) = __$DeviceFingerprintCopyWithImpl;
@override @useResult
$Res call({
 int androidSdk, String abi, String kernelVersion, bool selinuxEnforcing, String manufacturer, String model, bool isEmulator
});




}
/// @nodoc
class __$DeviceFingerprintCopyWithImpl<$Res>
    implements _$DeviceFingerprintCopyWith<$Res> {
  __$DeviceFingerprintCopyWithImpl(this._self, this._then);

  final _DeviceFingerprint _self;
  final $Res Function(_DeviceFingerprint) _then;

/// Create a copy of DeviceFingerprint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? androidSdk = null,Object? abi = null,Object? kernelVersion = null,Object? selinuxEnforcing = null,Object? manufacturer = null,Object? model = null,Object? isEmulator = null,}) {
  return _then(_DeviceFingerprint(
androidSdk: null == androidSdk ? _self.androidSdk : androidSdk // ignore: cast_nullable_to_non_nullable
as int,abi: null == abi ? _self.abi : abi // ignore: cast_nullable_to_non_nullable
as String,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,selinuxEnforcing: null == selinuxEnforcing ? _self.selinuxEnforcing : selinuxEnforcing // ignore: cast_nullable_to_non_nullable
as bool,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,isEmulator: null == isEmulator ? _self.isEmulator : isEmulator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
