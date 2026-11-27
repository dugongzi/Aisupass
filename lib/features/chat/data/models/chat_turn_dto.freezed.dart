// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_turn_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatTurnDto {

 String get id; String get role; String get text; String get reasoning; List<ChatToolCallDto> get toolCalls; String get error; String get rawError; String get notice; List<ChatAttachmentDto> get attachments; String get createdAt; int get durationMs; Map<String, dynamic> get usage;
/// Create a copy of ChatTurnDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatTurnDtoCopyWith<ChatTurnDto> get copyWith => _$ChatTurnDtoCopyWithImpl<ChatTurnDto>(this as ChatTurnDto, _$identity);

  /// Serializes this ChatTurnDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatTurnDto&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.text, text) || other.text == text)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&const DeepCollectionEquality().equals(other.toolCalls, toolCalls)&&(identical(other.error, error) || other.error == error)&&(identical(other.rawError, rawError) || other.rawError == rawError)&&(identical(other.notice, notice) || other.notice == notice)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&const DeepCollectionEquality().equals(other.usage, usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,text,reasoning,const DeepCollectionEquality().hash(toolCalls),error,rawError,notice,const DeepCollectionEquality().hash(attachments),createdAt,durationMs,const DeepCollectionEquality().hash(usage));

@override
String toString() {
  return 'ChatTurnDto(id: $id, role: $role, text: $text, reasoning: $reasoning, toolCalls: $toolCalls, error: $error, rawError: $rawError, notice: $notice, attachments: $attachments, createdAt: $createdAt, durationMs: $durationMs, usage: $usage)';
}


}

/// @nodoc
abstract mixin class $ChatTurnDtoCopyWith<$Res>  {
  factory $ChatTurnDtoCopyWith(ChatTurnDto value, $Res Function(ChatTurnDto) _then) = _$ChatTurnDtoCopyWithImpl;
@useResult
$Res call({
 String id, String role, String text, String reasoning, List<ChatToolCallDto> toolCalls, String error, String rawError, String notice, List<ChatAttachmentDto> attachments, String createdAt, int durationMs, Map<String, dynamic> usage
});




}
/// @nodoc
class _$ChatTurnDtoCopyWithImpl<$Res>
    implements $ChatTurnDtoCopyWith<$Res> {
  _$ChatTurnDtoCopyWithImpl(this._self, this._then);

  final ChatTurnDto _self;
  final $Res Function(ChatTurnDto) _then;

/// Create a copy of ChatTurnDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? text = null,Object? reasoning = null,Object? toolCalls = null,Object? error = null,Object? rawError = null,Object? notice = null,Object? attachments = null,Object? createdAt = null,Object? durationMs = null,Object? usage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as String,toolCalls: null == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<ChatToolCallDto>,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,rawError: null == rawError ? _self.rawError : rawError // ignore: cast_nullable_to_non_nullable
as String,notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatAttachmentDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatTurnDto].
extension ChatTurnDtoPatterns on ChatTurnDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatTurnDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatTurnDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatTurnDto value)  $default,){
final _that = this;
switch (_that) {
case _ChatTurnDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatTurnDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChatTurnDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String role,  String text,  String reasoning,  List<ChatToolCallDto> toolCalls,  String error,  String rawError,  String notice,  List<ChatAttachmentDto> attachments,  String createdAt,  int durationMs,  Map<String, dynamic> usage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatTurnDto() when $default != null:
return $default(_that.id,_that.role,_that.text,_that.reasoning,_that.toolCalls,_that.error,_that.rawError,_that.notice,_that.attachments,_that.createdAt,_that.durationMs,_that.usage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String role,  String text,  String reasoning,  List<ChatToolCallDto> toolCalls,  String error,  String rawError,  String notice,  List<ChatAttachmentDto> attachments,  String createdAt,  int durationMs,  Map<String, dynamic> usage)  $default,) {final _that = this;
switch (_that) {
case _ChatTurnDto():
return $default(_that.id,_that.role,_that.text,_that.reasoning,_that.toolCalls,_that.error,_that.rawError,_that.notice,_that.attachments,_that.createdAt,_that.durationMs,_that.usage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String role,  String text,  String reasoning,  List<ChatToolCallDto> toolCalls,  String error,  String rawError,  String notice,  List<ChatAttachmentDto> attachments,  String createdAt,  int durationMs,  Map<String, dynamic> usage)?  $default,) {final _that = this;
switch (_that) {
case _ChatTurnDto() when $default != null:
return $default(_that.id,_that.role,_that.text,_that.reasoning,_that.toolCalls,_that.error,_that.rawError,_that.notice,_that.attachments,_that.createdAt,_that.durationMs,_that.usage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatTurnDto extends ChatTurnDto {
  const _ChatTurnDto({this.id = '', this.role = '', this.text = '', this.reasoning = '', this.toolCalls = const <ChatToolCallDto>[], this.error = '', this.rawError = '', this.notice = '', this.attachments = const <ChatAttachmentDto>[], this.createdAt = '', this.durationMs = 0, this.usage = const <String, dynamic>{}}): super._();
  factory _ChatTurnDto.fromJson(Map<String, dynamic> json) => _$ChatTurnDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String role;
@override@JsonKey() final  String text;
@override@JsonKey() final  String reasoning;
@override@JsonKey() final  List<ChatToolCallDto> toolCalls;
@override@JsonKey() final  String error;
@override@JsonKey() final  String rawError;
@override@JsonKey() final  String notice;
@override@JsonKey() final  List<ChatAttachmentDto> attachments;
@override@JsonKey() final  String createdAt;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  Map<String, dynamic> usage;

/// Create a copy of ChatTurnDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatTurnDtoCopyWith<_ChatTurnDto> get copyWith => __$ChatTurnDtoCopyWithImpl<_ChatTurnDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatTurnDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatTurnDto&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.text, text) || other.text == text)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&const DeepCollectionEquality().equals(other.toolCalls, toolCalls)&&(identical(other.error, error) || other.error == error)&&(identical(other.rawError, rawError) || other.rawError == rawError)&&(identical(other.notice, notice) || other.notice == notice)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&const DeepCollectionEquality().equals(other.usage, usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,text,reasoning,const DeepCollectionEquality().hash(toolCalls),error,rawError,notice,const DeepCollectionEquality().hash(attachments),createdAt,durationMs,const DeepCollectionEquality().hash(usage));

@override
String toString() {
  return 'ChatTurnDto(id: $id, role: $role, text: $text, reasoning: $reasoning, toolCalls: $toolCalls, error: $error, rawError: $rawError, notice: $notice, attachments: $attachments, createdAt: $createdAt, durationMs: $durationMs, usage: $usage)';
}


}

/// @nodoc
abstract mixin class _$ChatTurnDtoCopyWith<$Res> implements $ChatTurnDtoCopyWith<$Res> {
  factory _$ChatTurnDtoCopyWith(_ChatTurnDto value, $Res Function(_ChatTurnDto) _then) = __$ChatTurnDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String role, String text, String reasoning, List<ChatToolCallDto> toolCalls, String error, String rawError, String notice, List<ChatAttachmentDto> attachments, String createdAt, int durationMs, Map<String, dynamic> usage
});




}
/// @nodoc
class __$ChatTurnDtoCopyWithImpl<$Res>
    implements _$ChatTurnDtoCopyWith<$Res> {
  __$ChatTurnDtoCopyWithImpl(this._self, this._then);

  final _ChatTurnDto _self;
  final $Res Function(_ChatTurnDto) _then;

/// Create a copy of ChatTurnDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? text = null,Object? reasoning = null,Object? toolCalls = null,Object? error = null,Object? rawError = null,Object? notice = null,Object? attachments = null,Object? createdAt = null,Object? durationMs = null,Object? usage = null,}) {
  return _then(_ChatTurnDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as String,toolCalls: null == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<ChatToolCallDto>,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,rawError: null == rawError ? _self.rawError : rawError // ignore: cast_nullable_to_non_nullable
as String,notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatAttachmentDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
