// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'root_manager_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RootManagerDto {

 String get packageName; String get displayName; List<int> get icon;
/// Create a copy of RootManagerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RootManagerDtoCopyWith<RootManagerDto> get copyWith => _$RootManagerDtoCopyWithImpl<RootManagerDto>(this as RootManagerDto, _$identity);

  /// Serializes this RootManagerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RootManagerDto&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.icon, icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageName,displayName,const DeepCollectionEquality().hash(icon));

@override
String toString() {
  return 'RootManagerDto(packageName: $packageName, displayName: $displayName, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $RootManagerDtoCopyWith<$Res>  {
  factory $RootManagerDtoCopyWith(RootManagerDto value, $Res Function(RootManagerDto) _then) = _$RootManagerDtoCopyWithImpl;
@useResult
$Res call({
 String packageName, String displayName, List<int> icon
});




}
/// @nodoc
class _$RootManagerDtoCopyWithImpl<$Res>
    implements $RootManagerDtoCopyWith<$Res> {
  _$RootManagerDtoCopyWithImpl(this._self, this._then);

  final RootManagerDto _self;
  final $Res Function(RootManagerDto) _then;

/// Create a copy of RootManagerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageName = null,Object? displayName = null,Object? icon = null,}) {
  return _then(_self.copyWith(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [RootManagerDto].
extension RootManagerDtoPatterns on RootManagerDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RootManagerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RootManagerDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RootManagerDto value)  $default,){
final _that = this;
switch (_that) {
case _RootManagerDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RootManagerDto value)?  $default,){
final _that = this;
switch (_that) {
case _RootManagerDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String packageName,  String displayName,  List<int> icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RootManagerDto() when $default != null:
return $default(_that.packageName,_that.displayName,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String packageName,  String displayName,  List<int> icon)  $default,) {final _that = this;
switch (_that) {
case _RootManagerDto():
return $default(_that.packageName,_that.displayName,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String packageName,  String displayName,  List<int> icon)?  $default,) {final _that = this;
switch (_that) {
case _RootManagerDto() when $default != null:
return $default(_that.packageName,_that.displayName,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RootManagerDto extends RootManagerDto {
  const _RootManagerDto({this.packageName = '', this.displayName = '', this.icon = const <int>[]}): super._();
  factory _RootManagerDto.fromJson(Map<String, dynamic> json) => _$RootManagerDtoFromJson(json);

@override@JsonKey() final  String packageName;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  List<int> icon;

/// Create a copy of RootManagerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RootManagerDtoCopyWith<_RootManagerDto> get copyWith => __$RootManagerDtoCopyWithImpl<_RootManagerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RootManagerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RootManagerDto&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.icon, icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageName,displayName,const DeepCollectionEquality().hash(icon));

@override
String toString() {
  return 'RootManagerDto(packageName: $packageName, displayName: $displayName, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$RootManagerDtoCopyWith<$Res> implements $RootManagerDtoCopyWith<$Res> {
  factory _$RootManagerDtoCopyWith(_RootManagerDto value, $Res Function(_RootManagerDto) _then) = __$RootManagerDtoCopyWithImpl;
@override @useResult
$Res call({
 String packageName, String displayName, List<int> icon
});




}
/// @nodoc
class __$RootManagerDtoCopyWithImpl<$Res>
    implements _$RootManagerDtoCopyWith<$Res> {
  __$RootManagerDtoCopyWithImpl(this._self, this._then);

  final _RootManagerDto _self;
  final $Res Function(_RootManagerDto) _then;

/// Create a copy of RootManagerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageName = null,Object? displayName = null,Object? icon = null,}) {
  return _then(_RootManagerDto(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
