// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_run_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EscalationRunRecord {

 String get runId; EscalationChain get chain; EscalationOutcome get outcome; List<EscalationStepRecord> get steps; int get startedAtMs; int get finishedAtMs; bool get residual;
/// Create a copy of EscalationRunRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationRunRecordCopyWith<EscalationRunRecord> get copyWith => _$EscalationRunRecordCopyWithImpl<EscalationRunRecord>(this as EscalationRunRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationRunRecord&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.finishedAtMs, finishedAtMs) || other.finishedAtMs == finishedAtMs)&&(identical(other.residual, residual) || other.residual == residual));
}


@override
int get hashCode => Object.hash(runtimeType,runId,chain,outcome,const DeepCollectionEquality().hash(steps),startedAtMs,finishedAtMs,residual);

@override
String toString() {
  return 'EscalationRunRecord(runId: $runId, chain: $chain, outcome: $outcome, steps: $steps, startedAtMs: $startedAtMs, finishedAtMs: $finishedAtMs, residual: $residual)';
}


}

/// @nodoc
abstract mixin class $EscalationRunRecordCopyWith<$Res>  {
  factory $EscalationRunRecordCopyWith(EscalationRunRecord value, $Res Function(EscalationRunRecord) _then) = _$EscalationRunRecordCopyWithImpl;
@useResult
$Res call({
 String runId, EscalationChain chain, EscalationOutcome outcome, List<EscalationStepRecord> steps, int startedAtMs, int finishedAtMs, bool residual
});




}
/// @nodoc
class _$EscalationRunRecordCopyWithImpl<$Res>
    implements $EscalationRunRecordCopyWith<$Res> {
  _$EscalationRunRecordCopyWithImpl(this._self, this._then);

  final EscalationRunRecord _self;
  final $Res Function(EscalationRunRecord) _then;

/// Create a copy of EscalationRunRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? chain = null,Object? outcome = null,Object? steps = null,Object? startedAtMs = null,Object? finishedAtMs = null,Object? residual = null,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as EscalationChain,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as EscalationOutcome,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<EscalationStepRecord>,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,finishedAtMs: null == finishedAtMs ? _self.finishedAtMs : finishedAtMs // ignore: cast_nullable_to_non_nullable
as int,residual: null == residual ? _self.residual : residual // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EscalationRunRecord].
extension EscalationRunRecordPatterns on EscalationRunRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationRunRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationRunRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationRunRecord value)  $default,){
final _that = this;
switch (_that) {
case _EscalationRunRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationRunRecord value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationRunRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  EscalationChain chain,  EscalationOutcome outcome,  List<EscalationStepRecord> steps,  int startedAtMs,  int finishedAtMs,  bool residual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationRunRecord() when $default != null:
return $default(_that.runId,_that.chain,_that.outcome,_that.steps,_that.startedAtMs,_that.finishedAtMs,_that.residual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  EscalationChain chain,  EscalationOutcome outcome,  List<EscalationStepRecord> steps,  int startedAtMs,  int finishedAtMs,  bool residual)  $default,) {final _that = this;
switch (_that) {
case _EscalationRunRecord():
return $default(_that.runId,_that.chain,_that.outcome,_that.steps,_that.startedAtMs,_that.finishedAtMs,_that.residual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  EscalationChain chain,  EscalationOutcome outcome,  List<EscalationStepRecord> steps,  int startedAtMs,  int finishedAtMs,  bool residual)?  $default,) {final _that = this;
switch (_that) {
case _EscalationRunRecord() when $default != null:
return $default(_that.runId,_that.chain,_that.outcome,_that.steps,_that.startedAtMs,_that.finishedAtMs,_that.residual);case _:
  return null;

}
}

}

/// @nodoc


class _EscalationRunRecord extends EscalationRunRecord {
  const _EscalationRunRecord({required this.runId, required this.chain, required this.outcome, required this.steps, required this.startedAtMs, required this.finishedAtMs, required this.residual}): super._();
  

@override final  String runId;
@override final  EscalationChain chain;
@override final  EscalationOutcome outcome;
@override final  List<EscalationStepRecord> steps;
@override final  int startedAtMs;
@override final  int finishedAtMs;
@override final  bool residual;

/// Create a copy of EscalationRunRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationRunRecordCopyWith<_EscalationRunRecord> get copyWith => __$EscalationRunRecordCopyWithImpl<_EscalationRunRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationRunRecord&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.finishedAtMs, finishedAtMs) || other.finishedAtMs == finishedAtMs)&&(identical(other.residual, residual) || other.residual == residual));
}


@override
int get hashCode => Object.hash(runtimeType,runId,chain,outcome,const DeepCollectionEquality().hash(steps),startedAtMs,finishedAtMs,residual);

@override
String toString() {
  return 'EscalationRunRecord(runId: $runId, chain: $chain, outcome: $outcome, steps: $steps, startedAtMs: $startedAtMs, finishedAtMs: $finishedAtMs, residual: $residual)';
}


}

/// @nodoc
abstract mixin class _$EscalationRunRecordCopyWith<$Res> implements $EscalationRunRecordCopyWith<$Res> {
  factory _$EscalationRunRecordCopyWith(_EscalationRunRecord value, $Res Function(_EscalationRunRecord) _then) = __$EscalationRunRecordCopyWithImpl;
@override @useResult
$Res call({
 String runId, EscalationChain chain, EscalationOutcome outcome, List<EscalationStepRecord> steps, int startedAtMs, int finishedAtMs, bool residual
});




}
/// @nodoc
class __$EscalationRunRecordCopyWithImpl<$Res>
    implements _$EscalationRunRecordCopyWith<$Res> {
  __$EscalationRunRecordCopyWithImpl(this._self, this._then);

  final _EscalationRunRecord _self;
  final $Res Function(_EscalationRunRecord) _then;

/// Create a copy of EscalationRunRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? chain = null,Object? outcome = null,Object? steps = null,Object? startedAtMs = null,Object? finishedAtMs = null,Object? residual = null,}) {
  return _then(_EscalationRunRecord(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as EscalationChain,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as EscalationOutcome,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<EscalationStepRecord>,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,finishedAtMs: null == finishedAtMs ? _self.finishedAtMs : finishedAtMs // ignore: cast_nullable_to_non_nullable
as int,residual: null == residual ? _self.residual : residual // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
