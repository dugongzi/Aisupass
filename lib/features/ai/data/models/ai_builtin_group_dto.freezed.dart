// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_builtin_group_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiBuiltinGroupDto {

 int get id; String get name; String get description; String get platform;@JsonKey(name: 'rate_multiplier') double get rateMultiplier;@JsonKey(name: 'is_exclusive') bool get isExclusive; List<AiBuiltinModelDto> get models;
/// Create a copy of AiBuiltinGroupDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBuiltinGroupDtoCopyWith<AiBuiltinGroupDto> get copyWith => _$AiBuiltinGroupDtoCopyWithImpl<AiBuiltinGroupDto>(this as AiBuiltinGroupDto, _$identity);

  /// Serializes this AiBuiltinGroupDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBuiltinGroupDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.rateMultiplier, rateMultiplier) || other.rateMultiplier == rateMultiplier)&&(identical(other.isExclusive, isExclusive) || other.isExclusive == isExclusive)&&const DeepCollectionEquality().equals(other.models, models));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,platform,rateMultiplier,isExclusive,const DeepCollectionEquality().hash(models));

@override
String toString() {
  return 'AiBuiltinGroupDto(id: $id, name: $name, description: $description, platform: $platform, rateMultiplier: $rateMultiplier, isExclusive: $isExclusive, models: $models)';
}


}

/// @nodoc
abstract mixin class $AiBuiltinGroupDtoCopyWith<$Res>  {
  factory $AiBuiltinGroupDtoCopyWith(AiBuiltinGroupDto value, $Res Function(AiBuiltinGroupDto) _then) = _$AiBuiltinGroupDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, String platform,@JsonKey(name: 'rate_multiplier') double rateMultiplier,@JsonKey(name: 'is_exclusive') bool isExclusive, List<AiBuiltinModelDto> models
});




}
/// @nodoc
class _$AiBuiltinGroupDtoCopyWithImpl<$Res>
    implements $AiBuiltinGroupDtoCopyWith<$Res> {
  _$AiBuiltinGroupDtoCopyWithImpl(this._self, this._then);

  final AiBuiltinGroupDto _self;
  final $Res Function(AiBuiltinGroupDto) _then;

/// Create a copy of AiBuiltinGroupDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? platform = null,Object? rateMultiplier = null,Object? isExclusive = null,Object? models = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,rateMultiplier: null == rateMultiplier ? _self.rateMultiplier : rateMultiplier // ignore: cast_nullable_to_non_nullable
as double,isExclusive: null == isExclusive ? _self.isExclusive : isExclusive // ignore: cast_nullable_to_non_nullable
as bool,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<AiBuiltinModelDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiBuiltinGroupDto].
extension AiBuiltinGroupDtoPatterns on AiBuiltinGroupDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBuiltinGroupDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBuiltinGroupDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBuiltinGroupDto value)  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinGroupDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBuiltinGroupDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinGroupDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String platform, @JsonKey(name: 'rate_multiplier')  double rateMultiplier, @JsonKey(name: 'is_exclusive')  bool isExclusive,  List<AiBuiltinModelDto> models)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBuiltinGroupDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.platform,_that.rateMultiplier,_that.isExclusive,_that.models);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String platform, @JsonKey(name: 'rate_multiplier')  double rateMultiplier, @JsonKey(name: 'is_exclusive')  bool isExclusive,  List<AiBuiltinModelDto> models)  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinGroupDto():
return $default(_that.id,_that.name,_that.description,_that.platform,_that.rateMultiplier,_that.isExclusive,_that.models);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  String platform, @JsonKey(name: 'rate_multiplier')  double rateMultiplier, @JsonKey(name: 'is_exclusive')  bool isExclusive,  List<AiBuiltinModelDto> models)?  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinGroupDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.platform,_that.rateMultiplier,_that.isExclusive,_that.models);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiBuiltinGroupDto extends AiBuiltinGroupDto {
  const _AiBuiltinGroupDto({this.id = 0, this.name = '', this.description = '', this.platform = '', @JsonKey(name: 'rate_multiplier') this.rateMultiplier = 1, @JsonKey(name: 'is_exclusive') this.isExclusive = false, this.models = const <AiBuiltinModelDto>[]}): super._();
  factory _AiBuiltinGroupDto.fromJson(Map<String, dynamic> json) => _$AiBuiltinGroupDtoFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String platform;
@override@JsonKey(name: 'rate_multiplier') final  double rateMultiplier;
@override@JsonKey(name: 'is_exclusive') final  bool isExclusive;
@override@JsonKey() final  List<AiBuiltinModelDto> models;

/// Create a copy of AiBuiltinGroupDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBuiltinGroupDtoCopyWith<_AiBuiltinGroupDto> get copyWith => __$AiBuiltinGroupDtoCopyWithImpl<_AiBuiltinGroupDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiBuiltinGroupDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBuiltinGroupDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.rateMultiplier, rateMultiplier) || other.rateMultiplier == rateMultiplier)&&(identical(other.isExclusive, isExclusive) || other.isExclusive == isExclusive)&&const DeepCollectionEquality().equals(other.models, models));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,platform,rateMultiplier,isExclusive,const DeepCollectionEquality().hash(models));

@override
String toString() {
  return 'AiBuiltinGroupDto(id: $id, name: $name, description: $description, platform: $platform, rateMultiplier: $rateMultiplier, isExclusive: $isExclusive, models: $models)';
}


}

/// @nodoc
abstract mixin class _$AiBuiltinGroupDtoCopyWith<$Res> implements $AiBuiltinGroupDtoCopyWith<$Res> {
  factory _$AiBuiltinGroupDtoCopyWith(_AiBuiltinGroupDto value, $Res Function(_AiBuiltinGroupDto) _then) = __$AiBuiltinGroupDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, String platform,@JsonKey(name: 'rate_multiplier') double rateMultiplier,@JsonKey(name: 'is_exclusive') bool isExclusive, List<AiBuiltinModelDto> models
});




}
/// @nodoc
class __$AiBuiltinGroupDtoCopyWithImpl<$Res>
    implements _$AiBuiltinGroupDtoCopyWith<$Res> {
  __$AiBuiltinGroupDtoCopyWithImpl(this._self, this._then);

  final _AiBuiltinGroupDto _self;
  final $Res Function(_AiBuiltinGroupDto) _then;

/// Create a copy of AiBuiltinGroupDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? platform = null,Object? rateMultiplier = null,Object? isExclusive = null,Object? models = null,}) {
  return _then(_AiBuiltinGroupDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,rateMultiplier: null == rateMultiplier ? _self.rateMultiplier : rateMultiplier // ignore: cast_nullable_to_non_nullable
as double,isExclusive: null == isExclusive ? _self.isExclusive : isExclusive // ignore: cast_nullable_to_non_nullable
as bool,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<AiBuiltinModelDto>,
  ));
}


}

// dart format on
