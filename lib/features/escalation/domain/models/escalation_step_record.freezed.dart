// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_step_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EscalationStepRecord {

 EscalationStage get stage; int get startedAtMs; int get durationMs; bool get ok; List<EscalationReason> get reasons; Map<String, String> get evidence;
/// Create a copy of EscalationStepRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationStepRecordCopyWith<EscalationStepRecord> get copyWith => _$EscalationStepRecordCopyWithImpl<EscalationStepRecord>(this as EscalationStepRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationStepRecord&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}


@override
int get hashCode => Object.hash(runtimeType,stage,startedAtMs,durationMs,ok,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'EscalationStepRecord(stage: $stage, startedAtMs: $startedAtMs, durationMs: $durationMs, ok: $ok, reasons: $reasons, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class $EscalationStepRecordCopyWith<$Res>  {
  factory $EscalationStepRecordCopyWith(EscalationStepRecord value, $Res Function(EscalationStepRecord) _then) = _$EscalationStepRecordCopyWithImpl;
@useResult
$Res call({
 EscalationStage stage, int startedAtMs, int durationMs, bool ok, List<EscalationReason> reasons, Map<String, String> evidence
});




}
/// @nodoc
class _$EscalationStepRecordCopyWithImpl<$Res>
    implements $EscalationStepRecordCopyWith<$Res> {
  _$EscalationStepRecordCopyWithImpl(this._self, this._then);

  final EscalationStepRecord _self;
  final $Res Function(EscalationStepRecord) _then;

/// Create a copy of EscalationStepRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? startedAtMs = null,Object? durationMs = null,Object? ok = null,Object? reasons = null,Object? evidence = null,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as EscalationStage,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<EscalationReason>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [EscalationStepRecord].
extension EscalationStepRecordPatterns on EscalationStepRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationStepRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationStepRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationStepRecord value)  $default,){
final _that = this;
switch (_that) {
case _EscalationStepRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationStepRecord value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationStepRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EscalationStage stage,  int startedAtMs,  int durationMs,  bool ok,  List<EscalationReason> reasons,  Map<String, String> evidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationStepRecord() when $default != null:
return $default(_that.stage,_that.startedAtMs,_that.durationMs,_that.ok,_that.reasons,_that.evidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EscalationStage stage,  int startedAtMs,  int durationMs,  bool ok,  List<EscalationReason> reasons,  Map<String, String> evidence)  $default,) {final _that = this;
switch (_that) {
case _EscalationStepRecord():
return $default(_that.stage,_that.startedAtMs,_that.durationMs,_that.ok,_that.reasons,_that.evidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EscalationStage stage,  int startedAtMs,  int durationMs,  bool ok,  List<EscalationReason> reasons,  Map<String, String> evidence)?  $default,) {final _that = this;
switch (_that) {
case _EscalationStepRecord() when $default != null:
return $default(_that.stage,_that.startedAtMs,_that.durationMs,_that.ok,_that.reasons,_that.evidence);case _:
  return null;

}
}

}

/// @nodoc


class _EscalationStepRecord extends EscalationStepRecord {
  const _EscalationStepRecord({required this.stage, required this.startedAtMs, required this.durationMs, required this.ok, required this.reasons, required this.evidence}): super._();
  

@override final  EscalationStage stage;
@override final  int startedAtMs;
@override final  int durationMs;
@override final  bool ok;
@override final  List<EscalationReason> reasons;
@override final  Map<String, String> evidence;

/// Create a copy of EscalationStepRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationStepRecordCopyWith<_EscalationStepRecord> get copyWith => __$EscalationStepRecordCopyWithImpl<_EscalationStepRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationStepRecord&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}


@override
int get hashCode => Object.hash(runtimeType,stage,startedAtMs,durationMs,ok,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'EscalationStepRecord(stage: $stage, startedAtMs: $startedAtMs, durationMs: $durationMs, ok: $ok, reasons: $reasons, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class _$EscalationStepRecordCopyWith<$Res> implements $EscalationStepRecordCopyWith<$Res> {
  factory _$EscalationStepRecordCopyWith(_EscalationStepRecord value, $Res Function(_EscalationStepRecord) _then) = __$EscalationStepRecordCopyWithImpl;
@override @useResult
$Res call({
 EscalationStage stage, int startedAtMs, int durationMs, bool ok, List<EscalationReason> reasons, Map<String, String> evidence
});




}
/// @nodoc
class __$EscalationStepRecordCopyWithImpl<$Res>
    implements _$EscalationStepRecordCopyWith<$Res> {
  __$EscalationStepRecordCopyWithImpl(this._self, this._then);

  final _EscalationStepRecord _self;
  final $Res Function(_EscalationStepRecord) _then;

/// Create a copy of EscalationStepRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? startedAtMs = null,Object? durationMs = null,Object? ok = null,Object? reasons = null,Object? evidence = null,}) {
  return _then(_EscalationStepRecord(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as EscalationStage,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<EscalationReason>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
