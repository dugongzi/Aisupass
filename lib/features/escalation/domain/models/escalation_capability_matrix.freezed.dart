// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_capability_matrix.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EscalationCapabilityMatrix {

 DeviceFingerprint get fingerprint; List<EscalationCapability> get capabilities; int get probedAtMs;
/// Create a copy of EscalationCapabilityMatrix
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationCapabilityMatrixCopyWith<EscalationCapabilityMatrix> get copyWith => _$EscalationCapabilityMatrixCopyWithImpl<EscalationCapabilityMatrix>(this as EscalationCapabilityMatrix, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationCapabilityMatrix&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&const DeepCollectionEquality().equals(other.capabilities, capabilities)&&(identical(other.probedAtMs, probedAtMs) || other.probedAtMs == probedAtMs));
}


@override
int get hashCode => Object.hash(runtimeType,fingerprint,const DeepCollectionEquality().hash(capabilities),probedAtMs);

@override
String toString() {
  return 'EscalationCapabilityMatrix(fingerprint: $fingerprint, capabilities: $capabilities, probedAtMs: $probedAtMs)';
}


}

/// @nodoc
abstract mixin class $EscalationCapabilityMatrixCopyWith<$Res>  {
  factory $EscalationCapabilityMatrixCopyWith(EscalationCapabilityMatrix value, $Res Function(EscalationCapabilityMatrix) _then) = _$EscalationCapabilityMatrixCopyWithImpl;
@useResult
$Res call({
 DeviceFingerprint fingerprint, List<EscalationCapability> capabilities, int probedAtMs
});


$DeviceFingerprintCopyWith<$Res> get fingerprint;

}
/// @nodoc
class _$EscalationCapabilityMatrixCopyWithImpl<$Res>
    implements $EscalationCapabilityMatrixCopyWith<$Res> {
  _$EscalationCapabilityMatrixCopyWithImpl(this._self, this._then);

  final EscalationCapabilityMatrix _self;
  final $Res Function(EscalationCapabilityMatrix) _then;

/// Create a copy of EscalationCapabilityMatrix
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fingerprint = null,Object? capabilities = null,Object? probedAtMs = null,}) {
  return _then(_self.copyWith(
fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as DeviceFingerprint,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as List<EscalationCapability>,probedAtMs: null == probedAtMs ? _self.probedAtMs : probedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of EscalationCapabilityMatrix
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceFingerprintCopyWith<$Res> get fingerprint {
  
  return $DeviceFingerprintCopyWith<$Res>(_self.fingerprint, (value) {
    return _then(_self.copyWith(fingerprint: value));
  });
}
}


/// Adds pattern-matching-related methods to [EscalationCapabilityMatrix].
extension EscalationCapabilityMatrixPatterns on EscalationCapabilityMatrix {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationCapabilityMatrix value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationCapabilityMatrix() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationCapabilityMatrix value)  $default,){
final _that = this;
switch (_that) {
case _EscalationCapabilityMatrix():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationCapabilityMatrix value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationCapabilityMatrix() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceFingerprint fingerprint,  List<EscalationCapability> capabilities,  int probedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationCapabilityMatrix() when $default != null:
return $default(_that.fingerprint,_that.capabilities,_that.probedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceFingerprint fingerprint,  List<EscalationCapability> capabilities,  int probedAtMs)  $default,) {final _that = this;
switch (_that) {
case _EscalationCapabilityMatrix():
return $default(_that.fingerprint,_that.capabilities,_that.probedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceFingerprint fingerprint,  List<EscalationCapability> capabilities,  int probedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _EscalationCapabilityMatrix() when $default != null:
return $default(_that.fingerprint,_that.capabilities,_that.probedAtMs);case _:
  return null;

}
}

}

/// @nodoc


class _EscalationCapabilityMatrix extends EscalationCapabilityMatrix {
  const _EscalationCapabilityMatrix({required this.fingerprint, required this.capabilities, required this.probedAtMs}): super._();
  

@override final  DeviceFingerprint fingerprint;
@override final  List<EscalationCapability> capabilities;
@override final  int probedAtMs;

/// Create a copy of EscalationCapabilityMatrix
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationCapabilityMatrixCopyWith<_EscalationCapabilityMatrix> get copyWith => __$EscalationCapabilityMatrixCopyWithImpl<_EscalationCapabilityMatrix>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationCapabilityMatrix&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&const DeepCollectionEquality().equals(other.capabilities, capabilities)&&(identical(other.probedAtMs, probedAtMs) || other.probedAtMs == probedAtMs));
}


@override
int get hashCode => Object.hash(runtimeType,fingerprint,const DeepCollectionEquality().hash(capabilities),probedAtMs);

@override
String toString() {
  return 'EscalationCapabilityMatrix(fingerprint: $fingerprint, capabilities: $capabilities, probedAtMs: $probedAtMs)';
}


}

/// @nodoc
abstract mixin class _$EscalationCapabilityMatrixCopyWith<$Res> implements $EscalationCapabilityMatrixCopyWith<$Res> {
  factory _$EscalationCapabilityMatrixCopyWith(_EscalationCapabilityMatrix value, $Res Function(_EscalationCapabilityMatrix) _then) = __$EscalationCapabilityMatrixCopyWithImpl;
@override @useResult
$Res call({
 DeviceFingerprint fingerprint, List<EscalationCapability> capabilities, int probedAtMs
});


@override $DeviceFingerprintCopyWith<$Res> get fingerprint;

}
/// @nodoc
class __$EscalationCapabilityMatrixCopyWithImpl<$Res>
    implements _$EscalationCapabilityMatrixCopyWith<$Res> {
  __$EscalationCapabilityMatrixCopyWithImpl(this._self, this._then);

  final _EscalationCapabilityMatrix _self;
  final $Res Function(_EscalationCapabilityMatrix) _then;

/// Create a copy of EscalationCapabilityMatrix
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fingerprint = null,Object? capabilities = null,Object? probedAtMs = null,}) {
  return _then(_EscalationCapabilityMatrix(
fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as DeviceFingerprint,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as List<EscalationCapability>,probedAtMs: null == probedAtMs ? _self.probedAtMs : probedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of EscalationCapabilityMatrix
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceFingerprintCopyWith<$Res> get fingerprint {
  
  return $DeviceFingerprintCopyWith<$Res>(_self.fingerprint, (value) {
    return _then(_self.copyWith(fingerprint: value));
  });
}
}

// dart format on
