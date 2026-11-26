// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_builtin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiBuiltinModel {

 String get name; String get platform; double get inputPrice; double get outputPrice;
/// Create a copy of AiBuiltinModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBuiltinModelCopyWith<AiBuiltinModel> get copyWith => _$AiBuiltinModelCopyWithImpl<AiBuiltinModel>(this as AiBuiltinModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBuiltinModel&&(identical(other.name, name) || other.name == name)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.inputPrice, inputPrice) || other.inputPrice == inputPrice)&&(identical(other.outputPrice, outputPrice) || other.outputPrice == outputPrice));
}


@override
int get hashCode => Object.hash(runtimeType,name,platform,inputPrice,outputPrice);

@override
String toString() {
  return 'AiBuiltinModel(name: $name, platform: $platform, inputPrice: $inputPrice, outputPrice: $outputPrice)';
}


}

/// @nodoc
abstract mixin class $AiBuiltinModelCopyWith<$Res>  {
  factory $AiBuiltinModelCopyWith(AiBuiltinModel value, $Res Function(AiBuiltinModel) _then) = _$AiBuiltinModelCopyWithImpl;
@useResult
$Res call({
 String name, String platform, double inputPrice, double outputPrice
});




}
/// @nodoc
class _$AiBuiltinModelCopyWithImpl<$Res>
    implements $AiBuiltinModelCopyWith<$Res> {
  _$AiBuiltinModelCopyWithImpl(this._self, this._then);

  final AiBuiltinModel _self;
  final $Res Function(AiBuiltinModel) _then;

/// Create a copy of AiBuiltinModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? platform = null,Object? inputPrice = null,Object? outputPrice = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,inputPrice: null == inputPrice ? _self.inputPrice : inputPrice // ignore: cast_nullable_to_non_nullable
as double,outputPrice: null == outputPrice ? _self.outputPrice : outputPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AiBuiltinModel].
extension AiBuiltinModelPatterns on AiBuiltinModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBuiltinModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBuiltinModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBuiltinModel value)  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBuiltinModel value)?  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String platform,  double inputPrice,  double outputPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBuiltinModel() when $default != null:
return $default(_that.name,_that.platform,_that.inputPrice,_that.outputPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String platform,  double inputPrice,  double outputPrice)  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinModel():
return $default(_that.name,_that.platform,_that.inputPrice,_that.outputPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String platform,  double inputPrice,  double outputPrice)?  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinModel() when $default != null:
return $default(_that.name,_that.platform,_that.inputPrice,_that.outputPrice);case _:
  return null;

}
}

}

/// @nodoc


class _AiBuiltinModel extends AiBuiltinModel {
  const _AiBuiltinModel({required this.name, required this.platform, required this.inputPrice, required this.outputPrice}): super._();
  

@override final  String name;
@override final  String platform;
@override final  double inputPrice;
@override final  double outputPrice;

/// Create a copy of AiBuiltinModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBuiltinModelCopyWith<_AiBuiltinModel> get copyWith => __$AiBuiltinModelCopyWithImpl<_AiBuiltinModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBuiltinModel&&(identical(other.name, name) || other.name == name)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.inputPrice, inputPrice) || other.inputPrice == inputPrice)&&(identical(other.outputPrice, outputPrice) || other.outputPrice == outputPrice));
}


@override
int get hashCode => Object.hash(runtimeType,name,platform,inputPrice,outputPrice);

@override
String toString() {
  return 'AiBuiltinModel(name: $name, platform: $platform, inputPrice: $inputPrice, outputPrice: $outputPrice)';
}


}

/// @nodoc
abstract mixin class _$AiBuiltinModelCopyWith<$Res> implements $AiBuiltinModelCopyWith<$Res> {
  factory _$AiBuiltinModelCopyWith(_AiBuiltinModel value, $Res Function(_AiBuiltinModel) _then) = __$AiBuiltinModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String platform, double inputPrice, double outputPrice
});




}
/// @nodoc
class __$AiBuiltinModelCopyWithImpl<$Res>
    implements _$AiBuiltinModelCopyWith<$Res> {
  __$AiBuiltinModelCopyWithImpl(this._self, this._then);

  final _AiBuiltinModel _self;
  final $Res Function(_AiBuiltinModel) _then;

/// Create a copy of AiBuiltinModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? platform = null,Object? inputPrice = null,Object? outputPrice = null,}) {
  return _then(_AiBuiltinModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,inputPrice: null == inputPrice ? _self.inputPrice : inputPrice // ignore: cast_nullable_to_non_nullable
as double,outputPrice: null == outputPrice ? _self.outputPrice : outputPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
