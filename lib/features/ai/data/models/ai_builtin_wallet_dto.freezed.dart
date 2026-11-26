// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_builtin_wallet_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiBuiltinWalletDto {

 double get balance;@JsonKey(name: 'frozen_balance') double get frozenBalance;
/// Create a copy of AiBuiltinWalletDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBuiltinWalletDtoCopyWith<AiBuiltinWalletDto> get copyWith => _$AiBuiltinWalletDtoCopyWithImpl<AiBuiltinWalletDto>(this as AiBuiltinWalletDto, _$identity);

  /// Serializes this AiBuiltinWalletDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBuiltinWalletDto&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.frozenBalance, frozenBalance) || other.frozenBalance == frozenBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,frozenBalance);

@override
String toString() {
  return 'AiBuiltinWalletDto(balance: $balance, frozenBalance: $frozenBalance)';
}


}

/// @nodoc
abstract mixin class $AiBuiltinWalletDtoCopyWith<$Res>  {
  factory $AiBuiltinWalletDtoCopyWith(AiBuiltinWalletDto value, $Res Function(AiBuiltinWalletDto) _then) = _$AiBuiltinWalletDtoCopyWithImpl;
@useResult
$Res call({
 double balance,@JsonKey(name: 'frozen_balance') double frozenBalance
});




}
/// @nodoc
class _$AiBuiltinWalletDtoCopyWithImpl<$Res>
    implements $AiBuiltinWalletDtoCopyWith<$Res> {
  _$AiBuiltinWalletDtoCopyWithImpl(this._self, this._then);

  final AiBuiltinWalletDto _self;
  final $Res Function(AiBuiltinWalletDto) _then;

/// Create a copy of AiBuiltinWalletDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? frozenBalance = null,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,frozenBalance: null == frozenBalance ? _self.frozenBalance : frozenBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AiBuiltinWalletDto].
extension AiBuiltinWalletDtoPatterns on AiBuiltinWalletDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBuiltinWalletDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBuiltinWalletDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBuiltinWalletDto value)  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinWalletDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBuiltinWalletDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinWalletDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double balance, @JsonKey(name: 'frozen_balance')  double frozenBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBuiltinWalletDto() when $default != null:
return $default(_that.balance,_that.frozenBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double balance, @JsonKey(name: 'frozen_balance')  double frozenBalance)  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinWalletDto():
return $default(_that.balance,_that.frozenBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double balance, @JsonKey(name: 'frozen_balance')  double frozenBalance)?  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinWalletDto() when $default != null:
return $default(_that.balance,_that.frozenBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiBuiltinWalletDto extends AiBuiltinWalletDto {
  const _AiBuiltinWalletDto({this.balance = 0, @JsonKey(name: 'frozen_balance') this.frozenBalance = 0}): super._();
  factory _AiBuiltinWalletDto.fromJson(Map<String, dynamic> json) => _$AiBuiltinWalletDtoFromJson(json);

@override@JsonKey() final  double balance;
@override@JsonKey(name: 'frozen_balance') final  double frozenBalance;

/// Create a copy of AiBuiltinWalletDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBuiltinWalletDtoCopyWith<_AiBuiltinWalletDto> get copyWith => __$AiBuiltinWalletDtoCopyWithImpl<_AiBuiltinWalletDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiBuiltinWalletDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBuiltinWalletDto&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.frozenBalance, frozenBalance) || other.frozenBalance == frozenBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,frozenBalance);

@override
String toString() {
  return 'AiBuiltinWalletDto(balance: $balance, frozenBalance: $frozenBalance)';
}


}

/// @nodoc
abstract mixin class _$AiBuiltinWalletDtoCopyWith<$Res> implements $AiBuiltinWalletDtoCopyWith<$Res> {
  factory _$AiBuiltinWalletDtoCopyWith(_AiBuiltinWalletDto value, $Res Function(_AiBuiltinWalletDto) _then) = __$AiBuiltinWalletDtoCopyWithImpl;
@override @useResult
$Res call({
 double balance,@JsonKey(name: 'frozen_balance') double frozenBalance
});




}
/// @nodoc
class __$AiBuiltinWalletDtoCopyWithImpl<$Res>
    implements _$AiBuiltinWalletDtoCopyWith<$Res> {
  __$AiBuiltinWalletDtoCopyWithImpl(this._self, this._then);

  final _AiBuiltinWalletDto _self;
  final $Res Function(_AiBuiltinWalletDto) _then;

/// Create a copy of AiBuiltinWalletDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? frozenBalance = null,}) {
  return _then(_AiBuiltinWalletDto(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,frozenBalance: null == frozenBalance ? _self.frozenBalance : frozenBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
