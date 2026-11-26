// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_builtin_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiBuiltinGroup {

 int get id; String get name; String get description; String get platform; double get rateMultiplier; bool get isExclusive; List<AiBuiltinModel> get models;
/// Create a copy of AiBuiltinGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBuiltinGroupCopyWith<AiBuiltinGroup> get copyWith => _$AiBuiltinGroupCopyWithImpl<AiBuiltinGroup>(this as AiBuiltinGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBuiltinGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.rateMultiplier, rateMultiplier) || other.rateMultiplier == rateMultiplier)&&(identical(other.isExclusive, isExclusive) || other.isExclusive == isExclusive)&&const DeepCollectionEquality().equals(other.models, models));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,platform,rateMultiplier,isExclusive,const DeepCollectionEquality().hash(models));

@override
String toString() {
  return 'AiBuiltinGroup(id: $id, name: $name, description: $description, platform: $platform, rateMultiplier: $rateMultiplier, isExclusive: $isExclusive, models: $models)';
}


}

/// @nodoc
abstract mixin class $AiBuiltinGroupCopyWith<$Res>  {
  factory $AiBuiltinGroupCopyWith(AiBuiltinGroup value, $Res Function(AiBuiltinGroup) _then) = _$AiBuiltinGroupCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, String platform, double rateMultiplier, bool isExclusive, List<AiBuiltinModel> models
});




}
/// @nodoc
class _$AiBuiltinGroupCopyWithImpl<$Res>
    implements $AiBuiltinGroupCopyWith<$Res> {
  _$AiBuiltinGroupCopyWithImpl(this._self, this._then);

  final AiBuiltinGroup _self;
  final $Res Function(AiBuiltinGroup) _then;

/// Create a copy of AiBuiltinGroup
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
as List<AiBuiltinModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiBuiltinGroup].
extension AiBuiltinGroupPatterns on AiBuiltinGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBuiltinGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBuiltinGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBuiltinGroup value)  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBuiltinGroup value)?  $default,){
final _that = this;
switch (_that) {
case _AiBuiltinGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String platform,  double rateMultiplier,  bool isExclusive,  List<AiBuiltinModel> models)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBuiltinGroup() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String platform,  double rateMultiplier,  bool isExclusive,  List<AiBuiltinModel> models)  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinGroup():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  String platform,  double rateMultiplier,  bool isExclusive,  List<AiBuiltinModel> models)?  $default,) {final _that = this;
switch (_that) {
case _AiBuiltinGroup() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.platform,_that.rateMultiplier,_that.isExclusive,_that.models);case _:
  return null;

}
}

}

/// @nodoc


class _AiBuiltinGroup extends AiBuiltinGroup {
  const _AiBuiltinGroup({required this.id, required this.name, required this.description, required this.platform, required this.rateMultiplier, required this.isExclusive, required this.models}): super._();
  

@override final  int id;
@override final  String name;
@override final  String description;
@override final  String platform;
@override final  double rateMultiplier;
@override final  bool isExclusive;
@override final  List<AiBuiltinModel> models;

/// Create a copy of AiBuiltinGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBuiltinGroupCopyWith<_AiBuiltinGroup> get copyWith => __$AiBuiltinGroupCopyWithImpl<_AiBuiltinGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBuiltinGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.rateMultiplier, rateMultiplier) || other.rateMultiplier == rateMultiplier)&&(identical(other.isExclusive, isExclusive) || other.isExclusive == isExclusive)&&const DeepCollectionEquality().equals(other.models, models));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,platform,rateMultiplier,isExclusive,const DeepCollectionEquality().hash(models));

@override
String toString() {
  return 'AiBuiltinGroup(id: $id, name: $name, description: $description, platform: $platform, rateMultiplier: $rateMultiplier, isExclusive: $isExclusive, models: $models)';
}


}

/// @nodoc
abstract mixin class _$AiBuiltinGroupCopyWith<$Res> implements $AiBuiltinGroupCopyWith<$Res> {
  factory _$AiBuiltinGroupCopyWith(_AiBuiltinGroup value, $Res Function(_AiBuiltinGroup) _then) = __$AiBuiltinGroupCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, String platform, double rateMultiplier, bool isExclusive, List<AiBuiltinModel> models
});




}
/// @nodoc
class __$AiBuiltinGroupCopyWithImpl<$Res>
    implements _$AiBuiltinGroupCopyWith<$Res> {
  __$AiBuiltinGroupCopyWithImpl(this._self, this._then);

  final _AiBuiltinGroup _self;
  final $Res Function(_AiBuiltinGroup) _then;

/// Create a copy of AiBuiltinGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? platform = null,Object? rateMultiplier = null,Object? isExclusive = null,Object? models = null,}) {
  return _then(_AiBuiltinGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,rateMultiplier: null == rateMultiplier ? _self.rateMultiplier : rateMultiplier // ignore: cast_nullable_to_non_nullable
as double,isExclusive: null == isExclusive ? _self.isExclusive : isExclusive // ignore: cast_nullable_to_non_nullable
as bool,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<AiBuiltinModel>,
  ));
}


}

// dart format on
