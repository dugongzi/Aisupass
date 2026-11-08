// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'root_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RootManager {

/// 管理器包名，同时是 `late-load --package-name` 的参数。
 String get packageName;/// 应用图标上显示的名字。
 String get displayName;/// 图标 PNG 字节；空数组表示取不到，UI 退回通用图标。
 Uint8List get icon;
/// Create a copy of RootManager
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RootManagerCopyWith<RootManager> get copyWith => _$RootManagerCopyWithImpl<RootManager>(this as RootManager, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RootManager&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.icon, icon));
}


@override
int get hashCode => Object.hash(runtimeType,packageName,displayName,const DeepCollectionEquality().hash(icon));

@override
String toString() {
  return 'RootManager(packageName: $packageName, displayName: $displayName, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $RootManagerCopyWith<$Res>  {
  factory $RootManagerCopyWith(RootManager value, $Res Function(RootManager) _then) = _$RootManagerCopyWithImpl;
@useResult
$Res call({
 String packageName, String displayName, Uint8List icon
});




}
/// @nodoc
class _$RootManagerCopyWithImpl<$Res>
    implements $RootManagerCopyWith<$Res> {
  _$RootManagerCopyWithImpl(this._self, this._then);

  final RootManager _self;
  final $Res Function(RootManager) _then;

/// Create a copy of RootManager
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageName = null,Object? displayName = null,Object? icon = null,}) {
  return _then(_self.copyWith(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}

}


/// Adds pattern-matching-related methods to [RootManager].
extension RootManagerPatterns on RootManager {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RootManager value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RootManager() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RootManager value)  $default,){
final _that = this;
switch (_that) {
case _RootManager():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RootManager value)?  $default,){
final _that = this;
switch (_that) {
case _RootManager() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String packageName,  String displayName,  Uint8List icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RootManager() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String packageName,  String displayName,  Uint8List icon)  $default,) {final _that = this;
switch (_that) {
case _RootManager():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String packageName,  String displayName,  Uint8List icon)?  $default,) {final _that = this;
switch (_that) {
case _RootManager() when $default != null:
return $default(_that.packageName,_that.displayName,_that.icon);case _:
  return null;

}
}

}

/// @nodoc


class _RootManager extends RootManager {
  const _RootManager({required this.packageName, required this.displayName, required this.icon}): super._();
  

/// 管理器包名，同时是 `late-load --package-name` 的参数。
@override final  String packageName;
/// 应用图标上显示的名字。
@override final  String displayName;
/// 图标 PNG 字节；空数组表示取不到，UI 退回通用图标。
@override final  Uint8List icon;

/// Create a copy of RootManager
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RootManagerCopyWith<_RootManager> get copyWith => __$RootManagerCopyWithImpl<_RootManager>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RootManager&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.icon, icon));
}


@override
int get hashCode => Object.hash(runtimeType,packageName,displayName,const DeepCollectionEquality().hash(icon));

@override
String toString() {
  return 'RootManager(packageName: $packageName, displayName: $displayName, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$RootManagerCopyWith<$Res> implements $RootManagerCopyWith<$Res> {
  factory _$RootManagerCopyWith(_RootManager value, $Res Function(_RootManager) _then) = __$RootManagerCopyWithImpl;
@override @useResult
$Res call({
 String packageName, String displayName, Uint8List icon
});




}
/// @nodoc
class __$RootManagerCopyWithImpl<$Res>
    implements _$RootManagerCopyWith<$Res> {
  __$RootManagerCopyWithImpl(this._self, this._then);

  final _RootManager _self;
  final $Res Function(_RootManager) _then;

/// Create a copy of RootManager
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageName = null,Object? displayName = null,Object? icon = null,}) {
  return _then(_RootManager(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

// dart format on
