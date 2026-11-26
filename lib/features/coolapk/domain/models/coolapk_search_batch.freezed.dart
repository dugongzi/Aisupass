// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_search_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoolapkSearchBatch {

 List<CoolapkSearchResult> get items;/// 服务端给出的总命中数；接口未返回时为 0。
 int get serverTotal;
/// Create a copy of CoolapkSearchBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkSearchBatchCopyWith<CoolapkSearchBatch> get copyWith => _$CoolapkSearchBatchCopyWithImpl<CoolapkSearchBatch>(this as CoolapkSearchBatch, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkSearchBatch&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.serverTotal, serverTotal) || other.serverTotal == serverTotal));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),serverTotal);

@override
String toString() {
  return 'CoolapkSearchBatch(items: $items, serverTotal: $serverTotal)';
}


}

/// @nodoc
abstract mixin class $CoolapkSearchBatchCopyWith<$Res>  {
  factory $CoolapkSearchBatchCopyWith(CoolapkSearchBatch value, $Res Function(CoolapkSearchBatch) _then) = _$CoolapkSearchBatchCopyWithImpl;
@useResult
$Res call({
 List<CoolapkSearchResult> items, int serverTotal
});




}
/// @nodoc
class _$CoolapkSearchBatchCopyWithImpl<$Res>
    implements $CoolapkSearchBatchCopyWith<$Res> {
  _$CoolapkSearchBatchCopyWithImpl(this._self, this._then);

  final CoolapkSearchBatch _self;
  final $Res Function(CoolapkSearchBatch) _then;

/// Create a copy of CoolapkSearchBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? serverTotal = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CoolapkSearchResult>,serverTotal: null == serverTotal ? _self.serverTotal : serverTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkSearchBatch].
extension CoolapkSearchBatchPatterns on CoolapkSearchBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkSearchBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkSearchBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkSearchBatch value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkSearchBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkSearchBatch value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkSearchBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CoolapkSearchResult> items,  int serverTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkSearchBatch() when $default != null:
return $default(_that.items,_that.serverTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CoolapkSearchResult> items,  int serverTotal)  $default,) {final _that = this;
switch (_that) {
case _CoolapkSearchBatch():
return $default(_that.items,_that.serverTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CoolapkSearchResult> items,  int serverTotal)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkSearchBatch() when $default != null:
return $default(_that.items,_that.serverTotal);case _:
  return null;

}
}

}

/// @nodoc


class _CoolapkSearchBatch extends CoolapkSearchBatch {
  const _CoolapkSearchBatch({required this.items, required this.serverTotal}): super._();
  

@override final  List<CoolapkSearchResult> items;
/// 服务端给出的总命中数；接口未返回时为 0。
@override final  int serverTotal;

/// Create a copy of CoolapkSearchBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkSearchBatchCopyWith<_CoolapkSearchBatch> get copyWith => __$CoolapkSearchBatchCopyWithImpl<_CoolapkSearchBatch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkSearchBatch&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.serverTotal, serverTotal) || other.serverTotal == serverTotal));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),serverTotal);

@override
String toString() {
  return 'CoolapkSearchBatch(items: $items, serverTotal: $serverTotal)';
}


}

/// @nodoc
abstract mixin class _$CoolapkSearchBatchCopyWith<$Res> implements $CoolapkSearchBatchCopyWith<$Res> {
  factory _$CoolapkSearchBatchCopyWith(_CoolapkSearchBatch value, $Res Function(_CoolapkSearchBatch) _then) = __$CoolapkSearchBatchCopyWithImpl;
@override @useResult
$Res call({
 List<CoolapkSearchResult> items, int serverTotal
});




}
/// @nodoc
class __$CoolapkSearchBatchCopyWithImpl<$Res>
    implements _$CoolapkSearchBatchCopyWith<$Res> {
  __$CoolapkSearchBatchCopyWithImpl(this._self, this._then);

  final _CoolapkSearchBatch _self;
  final $Res Function(_CoolapkSearchBatch) _then;

/// Create a copy of CoolapkSearchBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? serverTotal = null,}) {
  return _then(_CoolapkSearchBatch(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CoolapkSearchResult>,serverTotal: null == serverTotal ? _self.serverTotal : serverTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
