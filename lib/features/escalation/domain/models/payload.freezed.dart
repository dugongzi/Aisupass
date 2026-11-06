// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Payload {

/// 条目标识，catalog 内唯一。
 String get id;/// 载荷文件名，如 `libksu_vivo_iqoo13_6657_a.so`。
 String get library;/// 厂商，如 `vivo` / `google`。
 String get vendor;/// 展示名，如 `iQOO 13（6.6.57）`。
 String get displayName;/// 可匹配的机型关键词；无机型登记时为 `<String>[]`。
 List<String> get models;/// 内核版本是否未知。未知条目**禁止**进入自动匹配。
 bool get kernelUnknown;/// 内核版本，如 `6.6.57`；未知时为空串。
 String get kernelVersion;/// 该内核版本下可用的内核 `g<commit>` 前缀集合。
///
/// 空集表示「该条目无 commit 约束」，此时最多只能命中
/// [MatchTier.sameKernel]，不能进 [MatchTier.exact]。
 List<String> get kernelCommits;/// 构建号，仅展示用。
 String get buildId;/// 载荷体积（字节），仅用于打包自检。
 int get size;/// 载荷摘要，仅用于打包自检。
 String get sha256;/// catalog 里登记的执行命令**文案**，含 `<payload>` 等占位符，仅展示用。
///
/// 大部分条目写的是 `LD_PRELOAD=<payload> /system/bin/id`，跟本 App 的
/// 真实执行方式（助手 `dlopen`）无关，**不得当作命令执行**。
/// 真正的命令由 `EscalationActionRepositoryImpl` 按 [standalone] 拼。
 String get command;/// 是否为助手加载不了的独立可执行载荷。
///
/// 助手的 `--run-payload` 只做 `dlopen`。形如 `ET_EXEC` 的可执行文件
/// 无法被 `dlopen`，主体挂在 `DT_PREINIT_ARRAY` 的 PIE 也会被链接器跳过。
/// 清单里由 `"standalone": true` 显式标注，运行时**不解析 ELF 头**；
/// 这类载荷直接执行其本身，不经助手；参数取 [command] 里载荷路径之后的
/// 部分，`<内核版本的后三位>` 这类占位符补不齐就不执行。
 bool get standalone;/// 来源描述，仅展示用。
 String get source;
/// Create a copy of Payload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayloadCopyWith<Payload> get copyWith => _$PayloadCopyWithImpl<Payload>(this as Payload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payload&&(identical(other.id, id) || other.id == id)&&(identical(other.library, library) || other.library == library)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.models, models)&&(identical(other.kernelUnknown, kernelUnknown) || other.kernelUnknown == kernelUnknown)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&const DeepCollectionEquality().equals(other.kernelCommits, kernelCommits)&&(identical(other.buildId, buildId) || other.buildId == buildId)&&(identical(other.size, size) || other.size == size)&&(identical(other.sha256, sha256) || other.sha256 == sha256)&&(identical(other.command, command) || other.command == command)&&(identical(other.standalone, standalone) || other.standalone == standalone)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,library,vendor,displayName,const DeepCollectionEquality().hash(models),kernelUnknown,kernelVersion,const DeepCollectionEquality().hash(kernelCommits),buildId,size,sha256,command,standalone,source);

@override
String toString() {
  return 'Payload(id: $id, library: $library, vendor: $vendor, displayName: $displayName, models: $models, kernelUnknown: $kernelUnknown, kernelVersion: $kernelVersion, kernelCommits: $kernelCommits, buildId: $buildId, size: $size, sha256: $sha256, command: $command, standalone: $standalone, source: $source)';
}


}

/// @nodoc
abstract mixin class $PayloadCopyWith<$Res>  {
  factory $PayloadCopyWith(Payload value, $Res Function(Payload) _then) = _$PayloadCopyWithImpl;
@useResult
$Res call({
 String id, String library, String vendor, String displayName, List<String> models, bool kernelUnknown, String kernelVersion, List<String> kernelCommits, String buildId, int size, String sha256, String command, bool standalone, String source
});




}
/// @nodoc
class _$PayloadCopyWithImpl<$Res>
    implements $PayloadCopyWith<$Res> {
  _$PayloadCopyWithImpl(this._self, this._then);

  final Payload _self;
  final $Res Function(Payload) _then;

/// Create a copy of Payload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? library = null,Object? vendor = null,Object? displayName = null,Object? models = null,Object? kernelUnknown = null,Object? kernelVersion = null,Object? kernelCommits = null,Object? buildId = null,Object? size = null,Object? sha256 = null,Object? command = null,Object? standalone = null,Object? source = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,library: null == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as String,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<String>,kernelUnknown: null == kernelUnknown ? _self.kernelUnknown : kernelUnknown // ignore: cast_nullable_to_non_nullable
as bool,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,kernelCommits: null == kernelCommits ? _self.kernelCommits : kernelCommits // ignore: cast_nullable_to_non_nullable
as List<String>,buildId: null == buildId ? _self.buildId : buildId // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,standalone: null == standalone ? _self.standalone : standalone // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Payload].
extension PayloadPatterns on Payload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payload value)  $default,){
final _that = this;
switch (_that) {
case _Payload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payload value)?  $default,){
final _that = this;
switch (_that) {
case _Payload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String library,  String vendor,  String displayName,  List<String> models,  bool kernelUnknown,  String kernelVersion,  List<String> kernelCommits,  String buildId,  int size,  String sha256,  String command,  bool standalone,  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payload() when $default != null:
return $default(_that.id,_that.library,_that.vendor,_that.displayName,_that.models,_that.kernelUnknown,_that.kernelVersion,_that.kernelCommits,_that.buildId,_that.size,_that.sha256,_that.command,_that.standalone,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String library,  String vendor,  String displayName,  List<String> models,  bool kernelUnknown,  String kernelVersion,  List<String> kernelCommits,  String buildId,  int size,  String sha256,  String command,  bool standalone,  String source)  $default,) {final _that = this;
switch (_that) {
case _Payload():
return $default(_that.id,_that.library,_that.vendor,_that.displayName,_that.models,_that.kernelUnknown,_that.kernelVersion,_that.kernelCommits,_that.buildId,_that.size,_that.sha256,_that.command,_that.standalone,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String library,  String vendor,  String displayName,  List<String> models,  bool kernelUnknown,  String kernelVersion,  List<String> kernelCommits,  String buildId,  int size,  String sha256,  String command,  bool standalone,  String source)?  $default,) {final _that = this;
switch (_that) {
case _Payload() when $default != null:
return $default(_that.id,_that.library,_that.vendor,_that.displayName,_that.models,_that.kernelUnknown,_that.kernelVersion,_that.kernelCommits,_that.buildId,_that.size,_that.sha256,_that.command,_that.standalone,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _Payload extends Payload {
  const _Payload({required this.id, required this.library, required this.vendor, required this.displayName, required this.models, required this.kernelUnknown, required this.kernelVersion, required this.kernelCommits, required this.buildId, required this.size, required this.sha256, required this.command, required this.standalone, required this.source}): super._();
  

/// 条目标识，catalog 内唯一。
@override final  String id;
/// 载荷文件名，如 `libksu_vivo_iqoo13_6657_a.so`。
@override final  String library;
/// 厂商，如 `vivo` / `google`。
@override final  String vendor;
/// 展示名，如 `iQOO 13（6.6.57）`。
@override final  String displayName;
/// 可匹配的机型关键词；无机型登记时为 `<String>[]`。
@override final  List<String> models;
/// 内核版本是否未知。未知条目**禁止**进入自动匹配。
@override final  bool kernelUnknown;
/// 内核版本，如 `6.6.57`；未知时为空串。
@override final  String kernelVersion;
/// 该内核版本下可用的内核 `g<commit>` 前缀集合。
///
/// 空集表示「该条目无 commit 约束」，此时最多只能命中
/// [MatchTier.sameKernel]，不能进 [MatchTier.exact]。
@override final  List<String> kernelCommits;
/// 构建号，仅展示用。
@override final  String buildId;
/// 载荷体积（字节），仅用于打包自检。
@override final  int size;
/// 载荷摘要，仅用于打包自检。
@override final  String sha256;
/// catalog 里登记的执行命令**文案**，含 `<payload>` 等占位符，仅展示用。
///
/// 大部分条目写的是 `LD_PRELOAD=<payload> /system/bin/id`，跟本 App 的
/// 真实执行方式（助手 `dlopen`）无关，**不得当作命令执行**。
/// 真正的命令由 `EscalationActionRepositoryImpl` 按 [standalone] 拼。
@override final  String command;
/// 是否为助手加载不了的独立可执行载荷。
///
/// 助手的 `--run-payload` 只做 `dlopen`。形如 `ET_EXEC` 的可执行文件
/// 无法被 `dlopen`，主体挂在 `DT_PREINIT_ARRAY` 的 PIE 也会被链接器跳过。
/// 清单里由 `"standalone": true` 显式标注，运行时**不解析 ELF 头**；
/// 这类载荷直接执行其本身，不经助手；参数取 [command] 里载荷路径之后的
/// 部分，`<内核版本的后三位>` 这类占位符补不齐就不执行。
@override final  bool standalone;
/// 来源描述，仅展示用。
@override final  String source;

/// Create a copy of Payload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayloadCopyWith<_Payload> get copyWith => __$PayloadCopyWithImpl<_Payload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payload&&(identical(other.id, id) || other.id == id)&&(identical(other.library, library) || other.library == library)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.models, models)&&(identical(other.kernelUnknown, kernelUnknown) || other.kernelUnknown == kernelUnknown)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&const DeepCollectionEquality().equals(other.kernelCommits, kernelCommits)&&(identical(other.buildId, buildId) || other.buildId == buildId)&&(identical(other.size, size) || other.size == size)&&(identical(other.sha256, sha256) || other.sha256 == sha256)&&(identical(other.command, command) || other.command == command)&&(identical(other.standalone, standalone) || other.standalone == standalone)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,library,vendor,displayName,const DeepCollectionEquality().hash(models),kernelUnknown,kernelVersion,const DeepCollectionEquality().hash(kernelCommits),buildId,size,sha256,command,standalone,source);

@override
String toString() {
  return 'Payload(id: $id, library: $library, vendor: $vendor, displayName: $displayName, models: $models, kernelUnknown: $kernelUnknown, kernelVersion: $kernelVersion, kernelCommits: $kernelCommits, buildId: $buildId, size: $size, sha256: $sha256, command: $command, standalone: $standalone, source: $source)';
}


}

/// @nodoc
abstract mixin class _$PayloadCopyWith<$Res> implements $PayloadCopyWith<$Res> {
  factory _$PayloadCopyWith(_Payload value, $Res Function(_Payload) _then) = __$PayloadCopyWithImpl;
@override @useResult
$Res call({
 String id, String library, String vendor, String displayName, List<String> models, bool kernelUnknown, String kernelVersion, List<String> kernelCommits, String buildId, int size, String sha256, String command, bool standalone, String source
});




}
/// @nodoc
class __$PayloadCopyWithImpl<$Res>
    implements _$PayloadCopyWith<$Res> {
  __$PayloadCopyWithImpl(this._self, this._then);

  final _Payload _self;
  final $Res Function(_Payload) _then;

/// Create a copy of Payload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? library = null,Object? vendor = null,Object? displayName = null,Object? models = null,Object? kernelUnknown = null,Object? kernelVersion = null,Object? kernelCommits = null,Object? buildId = null,Object? size = null,Object? sha256 = null,Object? command = null,Object? standalone = null,Object? source = null,}) {
  return _then(_Payload(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,library: null == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as String,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<String>,kernelUnknown: null == kernelUnknown ? _self.kernelUnknown : kernelUnknown // ignore: cast_nullable_to_non_nullable
as bool,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,kernelCommits: null == kernelCommits ? _self.kernelCommits : kernelCommits // ignore: cast_nullable_to_non_nullable
as List<String>,buildId: null == buildId ? _self.buildId : buildId // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,standalone: null == standalone ? _self.standalone : standalone // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
