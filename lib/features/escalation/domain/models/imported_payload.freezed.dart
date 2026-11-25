// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imported_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportedPayload {

/// 列表里显示的名字，默认取文件名。
 String get displayName;/// 载荷在设备上的绝对路径。
 String get devicePath;/// `true` = 直接执行（可执行 ELF）；`false` = 交给包内助手加载（`.so`）。
 bool get standalone;/// 直接执行时附加的参数；助手加载方式下为空串。
 String get arguments;/// 文件体积（字节），仅展示。
 int get size;
/// Create a copy of ImportedPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportedPayloadCopyWith<ImportedPayload> get copyWith => _$ImportedPayloadCopyWithImpl<ImportedPayload>(this as ImportedPayload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportedPayload&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.devicePath, devicePath) || other.devicePath == devicePath)&&(identical(other.standalone, standalone) || other.standalone == standalone)&&(identical(other.arguments, arguments) || other.arguments == arguments)&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,displayName,devicePath,standalone,arguments,size);

@override
String toString() {
  return 'ImportedPayload(displayName: $displayName, devicePath: $devicePath, standalone: $standalone, arguments: $arguments, size: $size)';
}


}

/// @nodoc
abstract mixin class $ImportedPayloadCopyWith<$Res>  {
  factory $ImportedPayloadCopyWith(ImportedPayload value, $Res Function(ImportedPayload) _then) = _$ImportedPayloadCopyWithImpl;
@useResult
$Res call({
 String displayName, String devicePath, bool standalone, String arguments, int size
});




}
/// @nodoc
class _$ImportedPayloadCopyWithImpl<$Res>
    implements $ImportedPayloadCopyWith<$Res> {
  _$ImportedPayloadCopyWithImpl(this._self, this._then);

  final ImportedPayload _self;
  final $Res Function(ImportedPayload) _then;

/// Create a copy of ImportedPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? devicePath = null,Object? standalone = null,Object? arguments = null,Object? size = null,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,devicePath: null == devicePath ? _self.devicePath : devicePath // ignore: cast_nullable_to_non_nullable
as String,standalone: null == standalone ? _self.standalone : standalone // ignore: cast_nullable_to_non_nullable
as bool,arguments: null == arguments ? _self.arguments : arguments // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportedPayload].
extension ImportedPayloadPatterns on ImportedPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportedPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportedPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportedPayload value)  $default,){
final _that = this;
switch (_that) {
case _ImportedPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportedPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ImportedPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  String devicePath,  bool standalone,  String arguments,  int size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportedPayload() when $default != null:
return $default(_that.displayName,_that.devicePath,_that.standalone,_that.arguments,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  String devicePath,  bool standalone,  String arguments,  int size)  $default,) {final _that = this;
switch (_that) {
case _ImportedPayload():
return $default(_that.displayName,_that.devicePath,_that.standalone,_that.arguments,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  String devicePath,  bool standalone,  String arguments,  int size)?  $default,) {final _that = this;
switch (_that) {
case _ImportedPayload() when $default != null:
return $default(_that.displayName,_that.devicePath,_that.standalone,_that.arguments,_that.size);case _:
  return null;

}
}

}

/// @nodoc


class _ImportedPayload extends ImportedPayload {
  const _ImportedPayload({required this.displayName, required this.devicePath, required this.standalone, required this.arguments, required this.size}): super._();
  

/// 列表里显示的名字，默认取文件名。
@override final  String displayName;
/// 载荷在设备上的绝对路径。
@override final  String devicePath;
/// `true` = 直接执行（可执行 ELF）；`false` = 交给包内助手加载（`.so`）。
@override final  bool standalone;
/// 直接执行时附加的参数；助手加载方式下为空串。
@override final  String arguments;
/// 文件体积（字节），仅展示。
@override final  int size;

/// Create a copy of ImportedPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportedPayloadCopyWith<_ImportedPayload> get copyWith => __$ImportedPayloadCopyWithImpl<_ImportedPayload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportedPayload&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.devicePath, devicePath) || other.devicePath == devicePath)&&(identical(other.standalone, standalone) || other.standalone == standalone)&&(identical(other.arguments, arguments) || other.arguments == arguments)&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,displayName,devicePath,standalone,arguments,size);

@override
String toString() {
  return 'ImportedPayload(displayName: $displayName, devicePath: $devicePath, standalone: $standalone, arguments: $arguments, size: $size)';
}


}

/// @nodoc
abstract mixin class _$ImportedPayloadCopyWith<$Res> implements $ImportedPayloadCopyWith<$Res> {
  factory _$ImportedPayloadCopyWith(_ImportedPayload value, $Res Function(_ImportedPayload) _then) = __$ImportedPayloadCopyWithImpl;
@override @useResult
$Res call({
 String displayName, String devicePath, bool standalone, String arguments, int size
});




}
/// @nodoc
class __$ImportedPayloadCopyWithImpl<$Res>
    implements _$ImportedPayloadCopyWith<$Res> {
  __$ImportedPayloadCopyWithImpl(this._self, this._then);

  final _ImportedPayload _self;
  final $Res Function(_ImportedPayload) _then;

/// Create a copy of ImportedPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? devicePath = null,Object? standalone = null,Object? arguments = null,Object? size = null,}) {
  return _then(_ImportedPayload(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,devicePath: null == devicePath ? _self.devicePath : devicePath // ignore: cast_nullable_to_non_nullable
as String,standalone: null == standalone ? _self.standalone : standalone // ignore: cast_nullable_to_non_nullable
as bool,arguments: null == arguments ? _self.arguments : arguments // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
