// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payload_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayloadDto {

 String get id; String get library; String get vendor; String get displayName; List<String> get models; String get kernelVersion; String get buildId; int get size; String get sha256; String get command; String get source;
/// Create a copy of PayloadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayloadDtoCopyWith<PayloadDto> get copyWith => _$PayloadDtoCopyWithImpl<PayloadDto>(this as PayloadDto, _$identity);

  /// Serializes this PayloadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayloadDto&&(identical(other.id, id) || other.id == id)&&(identical(other.library, library) || other.library == library)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.models, models)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&(identical(other.buildId, buildId) || other.buildId == buildId)&&(identical(other.size, size) || other.size == size)&&(identical(other.sha256, sha256) || other.sha256 == sha256)&&(identical(other.command, command) || other.command == command)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,library,vendor,displayName,const DeepCollectionEquality().hash(models),kernelVersion,buildId,size,sha256,command,source);

@override
String toString() {
  return 'PayloadDto(id: $id, library: $library, vendor: $vendor, displayName: $displayName, models: $models, kernelVersion: $kernelVersion, buildId: $buildId, size: $size, sha256: $sha256, command: $command, source: $source)';
}


}

/// @nodoc
abstract mixin class $PayloadDtoCopyWith<$Res>  {
  factory $PayloadDtoCopyWith(PayloadDto value, $Res Function(PayloadDto) _then) = _$PayloadDtoCopyWithImpl;
@useResult
$Res call({
 String id, String library, String vendor, String displayName, List<String> models, String kernelVersion, String buildId, int size, String sha256, String command, String source
});




}
/// @nodoc
class _$PayloadDtoCopyWithImpl<$Res>
    implements $PayloadDtoCopyWith<$Res> {
  _$PayloadDtoCopyWithImpl(this._self, this._then);

  final PayloadDto _self;
  final $Res Function(PayloadDto) _then;

/// Create a copy of PayloadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? library = null,Object? vendor = null,Object? displayName = null,Object? models = null,Object? kernelVersion = null,Object? buildId = null,Object? size = null,Object? sha256 = null,Object? command = null,Object? source = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,library: null == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as String,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<String>,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,buildId: null == buildId ? _self.buildId : buildId // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PayloadDto].
extension PayloadDtoPatterns on PayloadDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayloadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayloadDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayloadDto value)  $default,){
final _that = this;
switch (_that) {
case _PayloadDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayloadDto value)?  $default,){
final _that = this;
switch (_that) {
case _PayloadDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String library,  String vendor,  String displayName,  List<String> models,  String kernelVersion,  String buildId,  int size,  String sha256,  String command,  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayloadDto() when $default != null:
return $default(_that.id,_that.library,_that.vendor,_that.displayName,_that.models,_that.kernelVersion,_that.buildId,_that.size,_that.sha256,_that.command,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String library,  String vendor,  String displayName,  List<String> models,  String kernelVersion,  String buildId,  int size,  String sha256,  String command,  String source)  $default,) {final _that = this;
switch (_that) {
case _PayloadDto():
return $default(_that.id,_that.library,_that.vendor,_that.displayName,_that.models,_that.kernelVersion,_that.buildId,_that.size,_that.sha256,_that.command,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String library,  String vendor,  String displayName,  List<String> models,  String kernelVersion,  String buildId,  int size,  String sha256,  String command,  String source)?  $default,) {final _that = this;
switch (_that) {
case _PayloadDto() when $default != null:
return $default(_that.id,_that.library,_that.vendor,_that.displayName,_that.models,_that.kernelVersion,_that.buildId,_that.size,_that.sha256,_that.command,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayloadDto extends PayloadDto {
  const _PayloadDto({this.id = '', this.library = '', this.vendor = '', this.displayName = '', this.models = const <String>[], this.kernelVersion = '', this.buildId = '', this.size = 0, this.sha256 = '', this.command = '', this.source = ''}): super._();
  factory _PayloadDto.fromJson(Map<String, dynamic> json) => _$PayloadDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String library;
@override@JsonKey() final  String vendor;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  List<String> models;
@override@JsonKey() final  String kernelVersion;
@override@JsonKey() final  String buildId;
@override@JsonKey() final  int size;
@override@JsonKey() final  String sha256;
@override@JsonKey() final  String command;
@override@JsonKey() final  String source;

/// Create a copy of PayloadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayloadDtoCopyWith<_PayloadDto> get copyWith => __$PayloadDtoCopyWithImpl<_PayloadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayloadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayloadDto&&(identical(other.id, id) || other.id == id)&&(identical(other.library, library) || other.library == library)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.models, models)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&(identical(other.buildId, buildId) || other.buildId == buildId)&&(identical(other.size, size) || other.size == size)&&(identical(other.sha256, sha256) || other.sha256 == sha256)&&(identical(other.command, command) || other.command == command)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,library,vendor,displayName,const DeepCollectionEquality().hash(models),kernelVersion,buildId,size,sha256,command,source);

@override
String toString() {
  return 'PayloadDto(id: $id, library: $library, vendor: $vendor, displayName: $displayName, models: $models, kernelVersion: $kernelVersion, buildId: $buildId, size: $size, sha256: $sha256, command: $command, source: $source)';
}


}

/// @nodoc
abstract mixin class _$PayloadDtoCopyWith<$Res> implements $PayloadDtoCopyWith<$Res> {
  factory _$PayloadDtoCopyWith(_PayloadDto value, $Res Function(_PayloadDto) _then) = __$PayloadDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String library, String vendor, String displayName, List<String> models, String kernelVersion, String buildId, int size, String sha256, String command, String source
});




}
/// @nodoc
class __$PayloadDtoCopyWithImpl<$Res>
    implements _$PayloadDtoCopyWith<$Res> {
  __$PayloadDtoCopyWithImpl(this._self, this._then);

  final _PayloadDto _self;
  final $Res Function(_PayloadDto) _then;

/// Create a copy of PayloadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? library = null,Object? vendor = null,Object? displayName = null,Object? models = null,Object? kernelVersion = null,Object? buildId = null,Object? size = null,Object? sha256 = null,Object? command = null,Object? source = null,}) {
  return _then(_PayloadDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,library: null == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as String,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<String>,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,buildId: null == buildId ? _self.buildId : buildId // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
