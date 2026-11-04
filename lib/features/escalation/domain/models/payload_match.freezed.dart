// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payload_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PayloadMatch {

/// 命中的载荷。
 Payload get payload;/// 命中档位。
 MatchTier get tier;
/// Create a copy of PayloadMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayloadMatchCopyWith<PayloadMatch> get copyWith => _$PayloadMatchCopyWithImpl<PayloadMatch>(this as PayloadMatch, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayloadMatch&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.tier, tier) || other.tier == tier));
}


@override
int get hashCode => Object.hash(runtimeType,payload,tier);

@override
String toString() {
  return 'PayloadMatch(payload: $payload, tier: $tier)';
}


}

/// @nodoc
abstract mixin class $PayloadMatchCopyWith<$Res>  {
  factory $PayloadMatchCopyWith(PayloadMatch value, $Res Function(PayloadMatch) _then) = _$PayloadMatchCopyWithImpl;
@useResult
$Res call({
 Payload payload, MatchTier tier
});


$PayloadCopyWith<$Res> get payload;

}
/// @nodoc
class _$PayloadMatchCopyWithImpl<$Res>
    implements $PayloadMatchCopyWith<$Res> {
  _$PayloadMatchCopyWithImpl(this._self, this._then);

  final PayloadMatch _self;
  final $Res Function(PayloadMatch) _then;

/// Create a copy of PayloadMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payload = null,Object? tier = null,}) {
  return _then(_self.copyWith(
payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Payload,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as MatchTier,
  ));
}
/// Create a copy of PayloadMatch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PayloadCopyWith<$Res> get payload {
  
  return $PayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// Adds pattern-matching-related methods to [PayloadMatch].
extension PayloadMatchPatterns on PayloadMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayloadMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayloadMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayloadMatch value)  $default,){
final _that = this;
switch (_that) {
case _PayloadMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayloadMatch value)?  $default,){
final _that = this;
switch (_that) {
case _PayloadMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Payload payload,  MatchTier tier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayloadMatch() when $default != null:
return $default(_that.payload,_that.tier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Payload payload,  MatchTier tier)  $default,) {final _that = this;
switch (_that) {
case _PayloadMatch():
return $default(_that.payload,_that.tier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Payload payload,  MatchTier tier)?  $default,) {final _that = this;
switch (_that) {
case _PayloadMatch() when $default != null:
return $default(_that.payload,_that.tier);case _:
  return null;

}
}

}

/// @nodoc


class _PayloadMatch extends PayloadMatch {
  const _PayloadMatch({required this.payload, required this.tier}): super._();
  

/// 命中的载荷。
@override final  Payload payload;
/// 命中档位。
@override final  MatchTier tier;

/// Create a copy of PayloadMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayloadMatchCopyWith<_PayloadMatch> get copyWith => __$PayloadMatchCopyWithImpl<_PayloadMatch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayloadMatch&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.tier, tier) || other.tier == tier));
}


@override
int get hashCode => Object.hash(runtimeType,payload,tier);

@override
String toString() {
  return 'PayloadMatch(payload: $payload, tier: $tier)';
}


}

/// @nodoc
abstract mixin class _$PayloadMatchCopyWith<$Res> implements $PayloadMatchCopyWith<$Res> {
  factory _$PayloadMatchCopyWith(_PayloadMatch value, $Res Function(_PayloadMatch) _then) = __$PayloadMatchCopyWithImpl;
@override @useResult
$Res call({
 Payload payload, MatchTier tier
});


@override $PayloadCopyWith<$Res> get payload;

}
/// @nodoc
class __$PayloadMatchCopyWithImpl<$Res>
    implements _$PayloadMatchCopyWith<$Res> {
  __$PayloadMatchCopyWithImpl(this._self, this._then);

  final _PayloadMatch _self;
  final $Res Function(_PayloadMatch) _then;

/// Create a copy of PayloadMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payload = null,Object? tier = null,}) {
  return _then(_PayloadMatch(
payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Payload,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as MatchTier,
  ));
}

/// Create a copy of PayloadMatch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PayloadCopyWith<$Res> get payload {
  
  return $PayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}

// dart format on
