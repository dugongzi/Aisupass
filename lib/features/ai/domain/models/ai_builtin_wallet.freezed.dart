// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_builtin_wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiBuiltinWallet {

 double get balance;
/// Create a copy of AiBuiltinWallet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBuiltinWalletCopyWith<AiBuiltinWallet> get copyWith => _$AiBuiltinWalletCopyWithImpl<AiBuiltinWallet>(this as AiBuiltinWallet, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBuiltinWallet&&(identical(other.balance, balance) || other.balance == balance));
}


@override
int get hashCode => Object.hash(runtimeType,balance);

@override
String toString() {
  return 'AiBuiltinWallet(balance: $balance)';
}


}

/// @nodoc
abstract mixin class $AiBuiltinWalletCopyWith<$Res>  {
  factory $AiBuiltinWalletCopyWith(AiBuiltinWallet value, $Res Function(AiBuiltinWallet) _then) = _$AiBuiltinWalletCopyWithImpl;
@useResult
$Res call({
 double balance
});




}
/// @nodoc
class _$AiBuiltinWalletCopyWithImpl<$Res>
    implements $AiBuiltinWalletCopyWith<$Res> {
  _$AiBuiltinWalletCopyWithImpl(this._self, this._then);

  final AiBuiltinWallet _self;
  final $Res Function(AiBuiltinWallet) _then;

/// Create a copy of AiBuiltinWallet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AiBuiltinWallet].
extension AiBuiltinWalletPatterns on AiBuiltinWallet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBuiltinWallet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBuiltinWallet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBuiltinWallet value)  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinWallet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBuiltinWallet value)?  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinWallet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBuiltinWallet() when $default != null:
return $default(_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double balance)  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinWallet():
return $default(_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double balance)?  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinWallet() when $default != null:
return $default(_that.balance);case _:
  return null;

}
}

}

/// @nodoc


class _AiBuiltinWallet extends AiBuiltinWallet {
  const _AiBuiltinWallet({required this.balance}): super._();
  

@override final  double balance;

/// Create a copy of AiBuiltinWallet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBuiltinWalletCopyWith<_AiBuiltinWallet> get copyWith => __$AiBuiltinWalletCopyWithImpl<_AiBuiltinWallet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBuiltinWallet&&(identical(other.balance, balance) || other.balance == balance));
}


@override
int get hashCode => Object.hash(runtimeType,balance);

@override
String toString() {
  return 'AiBuiltinWallet(balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$AiBuiltinWalletCopyWith<$Res> implements $AiBuiltinWalletCopyWith<$Res> {
  factory _$AiBuiltinWalletCopyWith(_AiBuiltinWallet value, $Res Function(_AiBuiltinWallet) _then) = __$AiBuiltinWalletCopyWithImpl;
@override @useResult
$Res call({
 double balance
});




}
/// @nodoc
class __$AiBuiltinWalletCopyWithImpl<$Res>
    implements _$AiBuiltinWalletCopyWith<$Res> {
  __$AiBuiltinWalletCopyWithImpl(this._self, this._then);

  final _AiBuiltinWallet _self;
  final $Res Function(_AiBuiltinWallet) _then;

/// Create a copy of AiBuiltinWallet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,}) {
  return _then(_AiBuiltinWallet(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
