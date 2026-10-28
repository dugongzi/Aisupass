// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_capability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EscalationCapability {

 EscalationChain get chain; bool get available; List<EscalationReason> get reasons; Map<String, String> get evidence;
/// Create a copy of EscalationCapability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationCapabilityCopyWith<EscalationCapability> get copyWith => _$EscalationCapabilityCopyWithImpl<EscalationCapability>(this as EscalationCapability, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationCapability&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}


@override
int get hashCode => Object.hash(runtimeType,chain,available,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'EscalationCapability(chain: $chain, available: $available, reasons: $reasons, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class $EscalationCapabilityCopyWith<$Res>  {
  factory $EscalationCapabilityCopyWith(EscalationCapability value, $Res Function(EscalationCapability) _then) = _$EscalationCapabilityCopyWithImpl;
@useResult
$Res call({
 EscalationChain chain, bool available, List<EscalationReason> reasons, Map<String, String> evidence
});




}
/// @nodoc
class _$EscalationCapabilityCopyWithImpl<$Res>
    implements $EscalationCapabilityCopyWith<$Res> {
  _$EscalationCapabilityCopyWithImpl(this._self, this._then);

  final EscalationCapability _self;
  final $Res Function(EscalationCapability) _then;

/// Create a copy of EscalationCapability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chain = null,Object? available = null,Object? reasons = null,Object? evidence = null,}) {
  return _then(_self.copyWith(
chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as EscalationChain,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<EscalationReason>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [EscalationCapability].
extension EscalationCapabilityPatterns on EscalationCapability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationCapability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationCapability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationCapability value)  $default,){
final _that = this;
switch (_that) {
case _EscalationCapability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationCapability value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationCapability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EscalationChain chain,  bool available,  List<EscalationReason> reasons,  Map<String, String> evidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationCapability() when $default != null:
return $default(_that.chain,_that.available,_that.reasons,_that.evidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EscalationChain chain,  bool available,  List<EscalationReason> reasons,  Map<String, String> evidence)  $default,) {final _that = this;
switch (_that) {
case _EscalationCapability():
return $default(_that.chain,_that.available,_that.reasons,_that.evidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EscalationChain chain,  bool available,  List<EscalationReason> reasons,  Map<String, String> evidence)?  $default,) {final _that = this;
switch (_that) {
case _EscalationCapability() when $default != null:
return $default(_that.chain,_that.available,_that.reasons,_that.evidence);case _:
  return null;

}
}

}

/// @nodoc


class _EscalationCapability extends EscalationCapability {
  const _EscalationCapability({required this.chain, required this.available, required this.reasons, required this.evidence}): super._();
  

@override final  EscalationChain chain;
@override final  bool available;
@override final  List<EscalationReason> reasons;
@override final  Map<String, String> evidence;

/// Create a copy of EscalationCapability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationCapabilityCopyWith<_EscalationCapability> get copyWith => __$EscalationCapabilityCopyWithImpl<_EscalationCapability>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationCapability&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}


@override
int get hashCode => Object.hash(runtimeType,chain,available,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'EscalationCapability(chain: $chain, available: $available, reasons: $reasons, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class _$EscalationCapabilityCopyWith<$Res> implements $EscalationCapabilityCopyWith<$Res> {
  factory _$EscalationCapabilityCopyWith(_EscalationCapability value, $Res Function(_EscalationCapability) _then) = __$EscalationCapabilityCopyWithImpl;
@override @useResult
$Res call({
 EscalationChain chain, bool available, List<EscalationReason> reasons, Map<String, String> evidence
});




}
/// @nodoc
class __$EscalationCapabilityCopyWithImpl<$Res>
    implements _$EscalationCapabilityCopyWith<$Res> {
  __$EscalationCapabilityCopyWithImpl(this._self, this._then);

  final _EscalationCapability _self;
  final $Res Function(_EscalationCapability) _then;

/// Create a copy of EscalationCapability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chain = null,Object? available = null,Object? reasons = null,Object? evidence = null,}) {
  return _then(_EscalationCapability(
chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as EscalationChain,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<EscalationReason>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
