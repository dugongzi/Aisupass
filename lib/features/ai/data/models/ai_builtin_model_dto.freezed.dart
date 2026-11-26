// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_builtin_model_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiBuiltinPricingDto {

@JsonKey(name: 'input_price') double get inputPrice;@JsonKey(name: 'output_price') double get outputPrice;
/// Create a copy of AiBuiltinPricingDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBuiltinPricingDtoCopyWith<AiBuiltinPricingDto> get copyWith => _$AiBuiltinPricingDtoCopyWithImpl<AiBuiltinPricingDto>(this as AiBuiltinPricingDto, _$identity);

  /// Serializes this AiBuiltinPricingDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBuiltinPricingDto&&(identical(other.inputPrice, inputPrice) || other.inputPrice == inputPrice)&&(identical(other.outputPrice, outputPrice) || other.outputPrice == outputPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inputPrice,outputPrice);

@override
String toString() {
  return 'AiBuiltinPricingDto(inputPrice: $inputPrice, outputPrice: $outputPrice)';
}


}

/// @nodoc
abstract mixin class $AiBuiltinPricingDtoCopyWith<$Res>  {
  factory $AiBuiltinPricingDtoCopyWith(AiBuiltinPricingDto value, $Res Function(AiBuiltinPricingDto) _then) = _$AiBuiltinPricingDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'input_price') double inputPrice,@JsonKey(name: 'output_price') double outputPrice
});




}
/// @nodoc
class _$AiBuiltinPricingDtoCopyWithImpl<$Res>
    implements $AiBuiltinPricingDtoCopyWith<$Res> {
  _$AiBuiltinPricingDtoCopyWithImpl(this._self, this._then);

  final AiBuiltinPricingDto _self;
  final $Res Function(AiBuiltinPricingDto) _then;

/// Create a copy of AiBuiltinPricingDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputPrice = null,Object? outputPrice = null,}) {
  return _then(_self.copyWith(
inputPrice: null == inputPrice ? _self.inputPrice : inputPrice // ignore: cast_nullable_to_non_nullable
as double,outputPrice: null == outputPrice ? _self.outputPrice : outputPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AiBuiltinPricingDto].
extension AiBuiltinPricingDtoPatterns on AiBuiltinPricingDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBuiltinPricingDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBuiltinPricingDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBuiltinPricingDto value)  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinPricingDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBuiltinPricingDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinPricingDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'input_price')  double inputPrice, @JsonKey(name: 'output_price')  double outputPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBuiltinPricingDto() when $default != null:
return $default(_that.inputPrice,_that.outputPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'input_price')  double inputPrice, @JsonKey(name: 'output_price')  double outputPrice)  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinPricingDto():
return $default(_that.inputPrice,_that.outputPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'input_price')  double inputPrice, @JsonKey(name: 'output_price')  double outputPrice)?  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinPricingDto() when $default != null:
return $default(_that.inputPrice,_that.outputPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiBuiltinPricingDto implements AiBuiltinPricingDto {
  const _AiBuiltinPricingDto({@JsonKey(name: 'input_price') this.inputPrice = 0, @JsonKey(name: 'output_price') this.outputPrice = 0});
  factory _AiBuiltinPricingDto.fromJson(Map<String, dynamic> json) => _$AiBuiltinPricingDtoFromJson(json);

@override@JsonKey(name: 'input_price') final  double inputPrice;
@override@JsonKey(name: 'output_price') final  double outputPrice;

/// Create a copy of AiBuiltinPricingDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBuiltinPricingDtoCopyWith<_AiBuiltinPricingDto> get copyWith => __$AiBuiltinPricingDtoCopyWithImpl<_AiBuiltinPricingDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiBuiltinPricingDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBuiltinPricingDto&&(identical(other.inputPrice, inputPrice) || other.inputPrice == inputPrice)&&(identical(other.outputPrice, outputPrice) || other.outputPrice == outputPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inputPrice,outputPrice);

@override
String toString() {
  return 'AiBuiltinPricingDto(inputPrice: $inputPrice, outputPrice: $outputPrice)';
}


}

/// @nodoc
abstract mixin class _$AiBuiltinPricingDtoCopyWith<$Res> implements $AiBuiltinPricingDtoCopyWith<$Res> {
  factory _$AiBuiltinPricingDtoCopyWith(_AiBuiltinPricingDto value, $Res Function(_AiBuiltinPricingDto) _then) = __$AiBuiltinPricingDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'input_price') double inputPrice,@JsonKey(name: 'output_price') double outputPrice
});




}
/// @nodoc
class __$AiBuiltinPricingDtoCopyWithImpl<$Res>
    implements _$AiBuiltinPricingDtoCopyWith<$Res> {
  __$AiBuiltinPricingDtoCopyWithImpl(this._self, this._then);

  final _AiBuiltinPricingDto _self;
  final $Res Function(_AiBuiltinPricingDto) _then;

/// Create a copy of AiBuiltinPricingDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputPrice = null,Object? outputPrice = null,}) {
  return _then(_AiBuiltinPricingDto(
inputPrice: null == inputPrice ? _self.inputPrice : inputPrice // ignore: cast_nullable_to_non_nullable
as double,outputPrice: null == outputPrice ? _self.outputPrice : outputPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AiBuiltinModelDto {

 String get name; String get platform; AiBuiltinPricingDto get pricing;
/// Create a copy of AiBuiltinModelDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBuiltinModelDtoCopyWith<AiBuiltinModelDto> get copyWith => _$AiBuiltinModelDtoCopyWithImpl<AiBuiltinModelDto>(this as AiBuiltinModelDto, _$identity);

  /// Serializes this AiBuiltinModelDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBuiltinModelDto&&(identical(other.name, name) || other.name == name)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.pricing, pricing) || other.pricing == pricing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,platform,pricing);

@override
String toString() {
  return 'AiBuiltinModelDto(name: $name, platform: $platform, pricing: $pricing)';
}


}

/// @nodoc
abstract mixin class $AiBuiltinModelDtoCopyWith<$Res>  {
  factory $AiBuiltinModelDtoCopyWith(AiBuiltinModelDto value, $Res Function(AiBuiltinModelDto) _then) = _$AiBuiltinModelDtoCopyWithImpl;
@useResult
$Res call({
 String name, String platform, AiBuiltinPricingDto pricing
});


$AiBuiltinPricingDtoCopyWith<$Res> get pricing;

}
/// @nodoc
class _$AiBuiltinModelDtoCopyWithImpl<$Res>
    implements $AiBuiltinModelDtoCopyWith<$Res> {
  _$AiBuiltinModelDtoCopyWithImpl(this._self, this._then);

  final AiBuiltinModelDto _self;
  final $Res Function(AiBuiltinModelDto) _then;

/// Create a copy of AiBuiltinModelDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? platform = null,Object? pricing = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,pricing: null == pricing ? _self.pricing : pricing // ignore: cast_nullable_to_non_nullable
as AiBuiltinPricingDto,
  ));
}
/// Create a copy of AiBuiltinModelDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiBuiltinPricingDtoCopyWith<$Res> get pricing {
  
  return $AiBuiltinPricingDtoCopyWith<$Res>(_self.pricing, (value) {
    return _then(_self.copyWith(pricing: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiBuiltinModelDto].
extension AiBuiltinModelDtoPatterns on AiBuiltinModelDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBuiltinModelDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBuiltinModelDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBuiltinModelDto value)  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinModelDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBuiltinModelDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinModelDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String platform,  AiBuiltinPricingDto pricing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBuiltinModelDto() when $default != null:
return $default(_that.name,_that.platform,_that.pricing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String platform,  AiBuiltinPricingDto pricing)  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinModelDto():
return $default(_that.name,_that.platform,_that.pricing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String platform,  AiBuiltinPricingDto pricing)?  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinModelDto() when $default != null:
return $default(_that.name,_that.platform,_that.pricing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiBuiltinModelDto extends AiBuiltinModelDto {
  const _AiBuiltinModelDto({this.name = '', this.platform = '', this.pricing = const AiBuiltinPricingDto()}): super._();
  factory _AiBuiltinModelDto.fromJson(Map<String, dynamic> json) => _$AiBuiltinModelDtoFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String platform;
@override@JsonKey() final  AiBuiltinPricingDto pricing;

/// Create a copy of AiBuiltinModelDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBuiltinModelDtoCopyWith<_AiBuiltinModelDto> get copyWith => __$AiBuiltinModelDtoCopyWithImpl<_AiBuiltinModelDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiBuiltinModelDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBuiltinModelDto&&(identical(other.name, name) || other.name == name)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.pricing, pricing) || other.pricing == pricing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,platform,pricing);

@override
String toString() {
  return 'AiBuiltinModelDto(name: $name, platform: $platform, pricing: $pricing)';
}


}

/// @nodoc
abstract mixin class _$AiBuiltinModelDtoCopyWith<$Res> implements $AiBuiltinModelDtoCopyWith<$Res> {
  factory _$AiBuiltinModelDtoCopyWith(_AiBuiltinModelDto value, $Res Function(_AiBuiltinModelDto) _then) = __$AiBuiltinModelDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String platform, AiBuiltinPricingDto pricing
});


@override $AiBuiltinPricingDtoCopyWith<$Res> get pricing;

}
/// @nodoc
class __$AiBuiltinModelDtoCopyWithImpl<$Res>
    implements _$AiBuiltinModelDtoCopyWith<$Res> {
  __$AiBuiltinModelDtoCopyWithImpl(this._self, this._then);

  final _AiBuiltinModelDto _self;
  final $Res Function(_AiBuiltinModelDto) _then;

/// Create a copy of AiBuiltinModelDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? platform = null,Object? pricing = null,}) {
  return _then(_AiBuiltinModelDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,pricing: null == pricing ? _self.pricing : pricing // ignore: cast_nullable_to_non_nullable
as AiBuiltinPricingDto,
  ));
}

/// Create a copy of AiBuiltinModelDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiBuiltinPricingDtoCopyWith<$Res> get pricing {
  
  return $AiBuiltinPricingDtoCopyWith<$Res>(_self.pricing, (value) {
    return _then(_self.copyWith(pricing: value));
  });
}
}

// dart format on
