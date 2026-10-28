// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_capability_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EscalationCapabilityDto {

 String get chain; bool get available; List<String> get reasons; Map<String, String> get evidence;
/// Create a copy of EscalationCapabilityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationCapabilityDtoCopyWith<EscalationCapabilityDto> get copyWith => _$EscalationCapabilityDtoCopyWithImpl<EscalationCapabilityDto>(this as EscalationCapabilityDto, _$identity);

  /// Serializes this EscalationCapabilityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationCapabilityDto&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chain,available,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'EscalationCapabilityDto(chain: $chain, available: $available, reasons: $reasons, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class $EscalationCapabilityDtoCopyWith<$Res>  {
  factory $EscalationCapabilityDtoCopyWith(EscalationCapabilityDto value, $Res Function(EscalationCapabilityDto) _then) = _$EscalationCapabilityDtoCopyWithImpl;
@useResult
$Res call({
 String chain, bool available, List<String> reasons, Map<String, String> evidence
});




}
/// @nodoc
class _$EscalationCapabilityDtoCopyWithImpl<$Res>
    implements $EscalationCapabilityDtoCopyWith<$Res> {
  _$EscalationCapabilityDtoCopyWithImpl(this._self, this._then);

  final EscalationCapabilityDto _self;
  final $Res Function(EscalationCapabilityDto) _then;

/// Create a copy of EscalationCapabilityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chain = null,Object? available = null,Object? reasons = null,Object? evidence = null,}) {
  return _then(_self.copyWith(
chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<String>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [EscalationCapabilityDto].
extension EscalationCapabilityDtoPatterns on EscalationCapabilityDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationCapabilityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationCapabilityDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationCapabilityDto value)  $default,){
final _that = this;
switch (_that) {
case _EscalationCapabilityDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationCapabilityDto value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationCapabilityDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chain,  bool available,  List<String> reasons,  Map<String, String> evidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationCapabilityDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chain,  bool available,  List<String> reasons,  Map<String, String> evidence)  $default,) {final _that = this;
switch (_that) {
case _EscalationCapabilityDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chain,  bool available,  List<String> reasons,  Map<String, String> evidence)?  $default,) {final _that = this;
switch (_that) {
case _EscalationCapabilityDto() when $default != null:
return $default(_that.chain,_that.available,_that.reasons,_that.evidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EscalationCapabilityDto extends EscalationCapabilityDto {
  const _EscalationCapabilityDto({this.chain = '', this.available = false, this.reasons = const <String>[], this.evidence = const <String, String>{}}): super._();
  factory _EscalationCapabilityDto.fromJson(Map<String, dynamic> json) => _$EscalationCapabilityDtoFromJson(json);

@override@JsonKey() final  String chain;
@override@JsonKey() final  bool available;
@override@JsonKey() final  List<String> reasons;
@override@JsonKey() final  Map<String, String> evidence;

/// Create a copy of EscalationCapabilityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationCapabilityDtoCopyWith<_EscalationCapabilityDto> get copyWith => __$EscalationCapabilityDtoCopyWithImpl<_EscalationCapabilityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EscalationCapabilityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationCapabilityDto&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chain,available,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'EscalationCapabilityDto(chain: $chain, available: $available, reasons: $reasons, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class _$EscalationCapabilityDtoCopyWith<$Res> implements $EscalationCapabilityDtoCopyWith<$Res> {
  factory _$EscalationCapabilityDtoCopyWith(_EscalationCapabilityDto value, $Res Function(_EscalationCapabilityDto) _then) = __$EscalationCapabilityDtoCopyWithImpl;
@override @useResult
$Res call({
 String chain, bool available, List<String> reasons, Map<String, String> evidence
});




}
/// @nodoc
class __$EscalationCapabilityDtoCopyWithImpl<$Res>
    implements _$EscalationCapabilityDtoCopyWith<$Res> {
  __$EscalationCapabilityDtoCopyWithImpl(this._self, this._then);

  final _EscalationCapabilityDto _self;
  final $Res Function(_EscalationCapabilityDto) _then;

/// Create a copy of EscalationCapabilityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chain = null,Object? available = null,Object? reasons = null,Object? evidence = null,}) {
  return _then(_EscalationCapabilityDto(
chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<String>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
