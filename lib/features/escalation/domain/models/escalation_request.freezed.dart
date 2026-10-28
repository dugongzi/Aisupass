// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EscalationRequest {

 EscalationChain get chain; Map<String, String> get args;
/// Create a copy of EscalationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationRequestCopyWith<EscalationRequest> get copyWith => _$EscalationRequestCopyWithImpl<EscalationRequest>(this as EscalationRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationRequest&&(identical(other.chain, chain) || other.chain == chain)&&const DeepCollectionEquality().equals(other.args, args));
}


@override
int get hashCode => Object.hash(runtimeType,chain,const DeepCollectionEquality().hash(args));

@override
String toString() {
  return 'EscalationRequest(chain: $chain, args: $args)';
}


}

/// @nodoc
abstract mixin class $EscalationRequestCopyWith<$Res>  {
  factory $EscalationRequestCopyWith(EscalationRequest value, $Res Function(EscalationRequest) _then) = _$EscalationRequestCopyWithImpl;
@useResult
$Res call({
 EscalationChain chain, Map<String, String> args
});




}
/// @nodoc
class _$EscalationRequestCopyWithImpl<$Res>
    implements $EscalationRequestCopyWith<$Res> {
  _$EscalationRequestCopyWithImpl(this._self, this._then);

  final EscalationRequest _self;
  final $Res Function(EscalationRequest) _then;

/// Create a copy of EscalationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chain = null,Object? args = null,}) {
  return _then(_self.copyWith(
chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as EscalationChain,args: null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [EscalationRequest].
extension EscalationRequestPatterns on EscalationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationRequest value)  $default,){
final _that = this;
switch (_that) {
case _EscalationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EscalationChain chain,  Map<String, String> args)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationRequest() when $default != null:
return $default(_that.chain,_that.args);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EscalationChain chain,  Map<String, String> args)  $default,) {final _that = this;
switch (_that) {
case _EscalationRequest():
return $default(_that.chain,_that.args);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EscalationChain chain,  Map<String, String> args)?  $default,) {final _that = this;
switch (_that) {
case _EscalationRequest() when $default != null:
return $default(_that.chain,_that.args);case _:
  return null;

}
}

}

/// @nodoc


class _EscalationRequest extends EscalationRequest {
  const _EscalationRequest({required this.chain, required this.args}): super._();
  

@override final  EscalationChain chain;
@override final  Map<String, String> args;

/// Create a copy of EscalationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationRequestCopyWith<_EscalationRequest> get copyWith => __$EscalationRequestCopyWithImpl<_EscalationRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationRequest&&(identical(other.chain, chain) || other.chain == chain)&&const DeepCollectionEquality().equals(other.args, args));
}


@override
int get hashCode => Object.hash(runtimeType,chain,const DeepCollectionEquality().hash(args));

@override
String toString() {
  return 'EscalationRequest(chain: $chain, args: $args)';
}


}

/// @nodoc
abstract mixin class _$EscalationRequestCopyWith<$Res> implements $EscalationRequestCopyWith<$Res> {
  factory _$EscalationRequestCopyWith(_EscalationRequest value, $Res Function(_EscalationRequest) _then) = __$EscalationRequestCopyWithImpl;
@override @useResult
$Res call({
 EscalationChain chain, Map<String, String> args
});




}
/// @nodoc
class __$EscalationRequestCopyWithImpl<$Res>
    implements _$EscalationRequestCopyWith<$Res> {
  __$EscalationRequestCopyWithImpl(this._self, this._then);

  final _EscalationRequest _self;
  final $Res Function(_EscalationRequest) _then;

/// Create a copy of EscalationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chain = null,Object? args = null,}) {
  return _then(_EscalationRequest(
chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as EscalationChain,args: null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
