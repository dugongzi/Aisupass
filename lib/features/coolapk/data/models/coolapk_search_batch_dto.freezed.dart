// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_search_batch_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoolapkSearchBatchDto {

 List<CoolapkSearchResultDto> get data;
/// Create a copy of CoolapkSearchBatchDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkSearchBatchDtoCopyWith<CoolapkSearchBatchDto> get copyWith => _$CoolapkSearchBatchDtoCopyWithImpl<CoolapkSearchBatchDto>(this as CoolapkSearchBatchDto, _$identity);

  /// Serializes this CoolapkSearchBatchDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkSearchBatchDto&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'CoolapkSearchBatchDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $CoolapkSearchBatchDtoCopyWith<$Res>  {
  factory $CoolapkSearchBatchDtoCopyWith(CoolapkSearchBatchDto value, $Res Function(CoolapkSearchBatchDto) _then) = _$CoolapkSearchBatchDtoCopyWithImpl;
@useResult
$Res call({
 List<CoolapkSearchResultDto> data
});




}
/// @nodoc
class _$CoolapkSearchBatchDtoCopyWithImpl<$Res>
    implements $CoolapkSearchBatchDtoCopyWith<$Res> {
  _$CoolapkSearchBatchDtoCopyWithImpl(this._self, this._then);

  final CoolapkSearchBatchDto _self;
  final $Res Function(CoolapkSearchBatchDto) _then;

/// Create a copy of CoolapkSearchBatchDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<CoolapkSearchResultDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkSearchBatchDto].
extension CoolapkSearchBatchDtoPatterns on CoolapkSearchBatchDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkSearchBatchDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkSearchBatchDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkSearchBatchDto value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkSearchBatchDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkSearchBatchDto value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkSearchBatchDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CoolapkSearchResultDto> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkSearchBatchDto() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CoolapkSearchResultDto> data)  $default,) {final _that = this;
switch (_that) {
case _CoolapkSearchBatchDto():
return $default(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CoolapkSearchResultDto> data)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkSearchBatchDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoolapkSearchBatchDto extends CoolapkSearchBatchDto {
  const _CoolapkSearchBatchDto({this.data = const <CoolapkSearchResultDto>[]}): super._();
  factory _CoolapkSearchBatchDto.fromJson(Map<String, dynamic> json) => _$CoolapkSearchBatchDtoFromJson(json);

@override@JsonKey() final  List<CoolapkSearchResultDto> data;

/// Create a copy of CoolapkSearchBatchDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkSearchBatchDtoCopyWith<_CoolapkSearchBatchDto> get copyWith => __$CoolapkSearchBatchDtoCopyWithImpl<_CoolapkSearchBatchDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoolapkSearchBatchDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkSearchBatchDto&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'CoolapkSearchBatchDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$CoolapkSearchBatchDtoCopyWith<$Res> implements $CoolapkSearchBatchDtoCopyWith<$Res> {
  factory _$CoolapkSearchBatchDtoCopyWith(_CoolapkSearchBatchDto value, $Res Function(_CoolapkSearchBatchDto) _then) = __$CoolapkSearchBatchDtoCopyWithImpl;
@override @useResult
$Res call({
 List<CoolapkSearchResultDto> data
});




}
/// @nodoc
class __$CoolapkSearchBatchDtoCopyWithImpl<$Res>
    implements _$CoolapkSearchBatchDtoCopyWith<$Res> {
  __$CoolapkSearchBatchDtoCopyWithImpl(this._self, this._then);

  final _CoolapkSearchBatchDto _self;
  final $Res Function(_CoolapkSearchBatchDto) _then;

/// Create a copy of CoolapkSearchBatchDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_CoolapkSearchBatchDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<CoolapkSearchResultDto>,
  ));
}


}

// dart format on
