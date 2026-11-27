// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_turn.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatTurn {

 String get id; ChatRole get role; String get text; String get reasoning; List<ChatToolCall> get toolCalls; bool get streaming; String get error; ChatNotice get notice;/// 失败时服务端返回的原始响应正文。
///
/// 界面上原样展开给用户看，避免只给一句概括让用户猜原因。
 String get rawError;/// 用户消息附带的图片或文本文件，assistant 轮次恒为空。
 List<ChatAttachment> get attachments;/// 轮次创建时间；`0` 表示未记录。
 DateTime get createdAt;/// 本轮模型调用的总耗时；`Duration.zero` 表示未记录。
 Duration get duration;/// 本轮模型调用的 token 用量。
 ChatUsage get usage;
/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatTurnCopyWith<ChatTurn> get copyWith => _$ChatTurnCopyWithImpl<ChatTurn>(this as ChatTurn, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatTurn&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.text, text) || other.text == text)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&const DeepCollectionEquality().equals(other.toolCalls, toolCalls)&&(identical(other.streaming, streaming) || other.streaming == streaming)&&(identical(other.error, error) || other.error == error)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.rawError, rawError) || other.rawError == rawError)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.usage, usage) || other.usage == usage));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,text,reasoning,const DeepCollectionEquality().hash(toolCalls),streaming,error,notice,rawError,const DeepCollectionEquality().hash(attachments),createdAt,duration,usage);

@override
String toString() {
  return 'ChatTurn(id: $id, role: $role, text: $text, reasoning: $reasoning, toolCalls: $toolCalls, streaming: $streaming, error: $error, notice: $notice, rawError: $rawError, attachments: $attachments, createdAt: $createdAt, duration: $duration, usage: $usage)';
}


}

/// @nodoc
abstract mixin class $ChatTurnCopyWith<$Res>  {
  factory $ChatTurnCopyWith(ChatTurn value, $Res Function(ChatTurn) _then) = _$ChatTurnCopyWithImpl;
@useResult
$Res call({
 String id, ChatRole role, String text, String reasoning, List<ChatToolCall> toolCalls, bool streaming, String error, ChatNotice notice, String rawError, List<ChatAttachment> attachments, DateTime createdAt, Duration duration, ChatUsage usage
});


$ChatUsageCopyWith<$Res> get usage;

}
/// @nodoc
class _$ChatTurnCopyWithImpl<$Res>
    implements $ChatTurnCopyWith<$Res> {
  _$ChatTurnCopyWithImpl(this._self, this._then);

  final ChatTurn _self;
  final $Res Function(ChatTurn) _then;

/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? text = null,Object? reasoning = null,Object? toolCalls = null,Object? streaming = null,Object? error = null,Object? notice = null,Object? rawError = null,Object? attachments = null,Object? createdAt = null,Object? duration = null,Object? usage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as String,toolCalls: null == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<ChatToolCall>,streaming: null == streaming ? _self.streaming : streaming // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as ChatNotice,rawError: null == rawError ? _self.rawError : rawError // ignore: cast_nullable_to_non_nullable
as String,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatAttachment>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as ChatUsage,
  ));
}
/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUsageCopyWith<$Res> get usage {
  
  return $ChatUsageCopyWith<$Res>(_self.usage, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatTurn].
extension ChatTurnPatterns on ChatTurn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatTurn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatTurn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatTurn value)  $default,){
final _that = this;
switch (_that) {
case _ChatTurn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatTurn value)?  $default,){
final _that = this;
switch (_that) {
case _ChatTurn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ChatRole role,  String text,  String reasoning,  List<ChatToolCall> toolCalls,  bool streaming,  String error,  ChatNotice notice,  String rawError,  List<ChatAttachment> attachments,  DateTime createdAt,  Duration duration,  ChatUsage usage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatTurn() when $default != null:
return $default(_that.id,_that.role,_that.text,_that.reasoning,_that.toolCalls,_that.streaming,_that.error,_that.notice,_that.rawError,_that.attachments,_that.createdAt,_that.duration,_that.usage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ChatRole role,  String text,  String reasoning,  List<ChatToolCall> toolCalls,  bool streaming,  String error,  ChatNotice notice,  String rawError,  List<ChatAttachment> attachments,  DateTime createdAt,  Duration duration,  ChatUsage usage)  $default,) {final _that = this;
switch (_that) {
case _ChatTurn():
return $default(_that.id,_that.role,_that.text,_that.reasoning,_that.toolCalls,_that.streaming,_that.error,_that.notice,_that.rawError,_that.attachments,_that.createdAt,_that.duration,_that.usage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ChatRole role,  String text,  String reasoning,  List<ChatToolCall> toolCalls,  bool streaming,  String error,  ChatNotice notice,  String rawError,  List<ChatAttachment> attachments,  DateTime createdAt,  Duration duration,  ChatUsage usage)?  $default,) {final _that = this;
switch (_that) {
case _ChatTurn() when $default != null:
return $default(_that.id,_that.role,_that.text,_that.reasoning,_that.toolCalls,_that.streaming,_that.error,_that.notice,_that.rawError,_that.attachments,_that.createdAt,_that.duration,_that.usage);case _:
  return null;

}
}

}

/// @nodoc


class _ChatTurn extends ChatTurn {
  const _ChatTurn({required this.id, required this.role, required this.text, required this.reasoning, required this.toolCalls, required this.streaming, required this.error, required this.notice, this.rawError = '', this.attachments = const <ChatAttachment>[], required this.createdAt, required this.duration, required this.usage}): super._();
  

@override final  String id;
@override final  ChatRole role;
@override final  String text;
@override final  String reasoning;
@override final  List<ChatToolCall> toolCalls;
@override final  bool streaming;
@override final  String error;
@override final  ChatNotice notice;
/// 失败时服务端返回的原始响应正文。
///
/// 界面上原样展开给用户看，避免只给一句概括让用户猜原因。
@override@JsonKey() final  String rawError;
/// 用户消息附带的图片或文本文件，assistant 轮次恒为空。
@override@JsonKey() final  List<ChatAttachment> attachments;
/// 轮次创建时间；`0` 表示未记录。
@override final  DateTime createdAt;
/// 本轮模型调用的总耗时；`Duration.zero` 表示未记录。
@override final  Duration duration;
/// 本轮模型调用的 token 用量。
@override final  ChatUsage usage;

/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatTurnCopyWith<_ChatTurn> get copyWith => __$ChatTurnCopyWithImpl<_ChatTurn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatTurn&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.text, text) || other.text == text)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&const DeepCollectionEquality().equals(other.toolCalls, toolCalls)&&(identical(other.streaming, streaming) || other.streaming == streaming)&&(identical(other.error, error) || other.error == error)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.rawError, rawError) || other.rawError == rawError)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.usage, usage) || other.usage == usage));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,text,reasoning,const DeepCollectionEquality().hash(toolCalls),streaming,error,notice,rawError,const DeepCollectionEquality().hash(attachments),createdAt,duration,usage);

@override
String toString() {
  return 'ChatTurn(id: $id, role: $role, text: $text, reasoning: $reasoning, toolCalls: $toolCalls, streaming: $streaming, error: $error, notice: $notice, rawError: $rawError, attachments: $attachments, createdAt: $createdAt, duration: $duration, usage: $usage)';
}


}

/// @nodoc
abstract mixin class _$ChatTurnCopyWith<$Res> implements $ChatTurnCopyWith<$Res> {
  factory _$ChatTurnCopyWith(_ChatTurn value, $Res Function(_ChatTurn) _then) = __$ChatTurnCopyWithImpl;
@override @useResult
$Res call({
 String id, ChatRole role, String text, String reasoning, List<ChatToolCall> toolCalls, bool streaming, String error, ChatNotice notice, String rawError, List<ChatAttachment> attachments, DateTime createdAt, Duration duration, ChatUsage usage
});


@override $ChatUsageCopyWith<$Res> get usage;

}
/// @nodoc
class __$ChatTurnCopyWithImpl<$Res>
    implements _$ChatTurnCopyWith<$Res> {
  __$ChatTurnCopyWithImpl(this._self, this._then);

  final _ChatTurn _self;
  final $Res Function(_ChatTurn) _then;

/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? text = null,Object? reasoning = null,Object? toolCalls = null,Object? streaming = null,Object? error = null,Object? notice = null,Object? rawError = null,Object? attachments = null,Object? createdAt = null,Object? duration = null,Object? usage = null,}) {
  return _then(_ChatTurn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as String,toolCalls: null == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<ChatToolCall>,streaming: null == streaming ? _self.streaming : streaming // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as ChatNotice,rawError: null == rawError ? _self.rawError : rawError // ignore: cast_nullable_to_non_nullable
as String,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatAttachment>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as ChatUsage,
  ));
}

/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUsageCopyWith<$Res> get usage {
  
  return $ChatUsageCopyWith<$Res>(_self.usage, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}

// dart format on
