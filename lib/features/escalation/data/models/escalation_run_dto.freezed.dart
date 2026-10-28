// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_run_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EscalationStepDto {

 String get stage; int get startedAtMs; int get durationMs; bool get ok; List<String> get reasons; Map<String, String> get evidence;
/// Create a copy of EscalationStepDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationStepDtoCopyWith<EscalationStepDto> get copyWith => _$EscalationStepDtoCopyWithImpl<EscalationStepDto>(this as EscalationStepDto, _$identity);

  /// Serializes this EscalationStepDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationStepDto&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stage,startedAtMs,durationMs,ok,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'EscalationStepDto(stage: $stage, startedAtMs: $startedAtMs, durationMs: $durationMs, ok: $ok, reasons: $reasons, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class $EscalationStepDtoCopyWith<$Res>  {
  factory $EscalationStepDtoCopyWith(EscalationStepDto value, $Res Function(EscalationStepDto) _then) = _$EscalationStepDtoCopyWithImpl;
@useResult
$Res call({
 String stage, int startedAtMs, int durationMs, bool ok, List<String> reasons, Map<String, String> evidence
});




}
/// @nodoc
class _$EscalationStepDtoCopyWithImpl<$Res>
    implements $EscalationStepDtoCopyWith<$Res> {
  _$EscalationStepDtoCopyWithImpl(this._self, this._then);

  final EscalationStepDto _self;
  final $Res Function(EscalationStepDto) _then;

/// Create a copy of EscalationStepDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? startedAtMs = null,Object? durationMs = null,Object? ok = null,Object? reasons = null,Object? evidence = null,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<String>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [EscalationStepDto].
extension EscalationStepDtoPatterns on EscalationStepDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationStepDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationStepDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationStepDto value)  $default,){
final _that = this;
switch (_that) {
case _EscalationStepDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationStepDto value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationStepDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stage,  int startedAtMs,  int durationMs,  bool ok,  List<String> reasons,  Map<String, String> evidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationStepDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stage,  int startedAtMs,  int durationMs,  bool ok,  List<String> reasons,  Map<String, String> evidence)  $default,) {final _that = this;
switch (_that) {
case _EscalationStepDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stage,  int startedAtMs,  int durationMs,  bool ok,  List<String> reasons,  Map<String, String> evidence)?  $default,) {final _that = this;
switch (_that) {
case _EscalationStepDto() when $default != null:
return $default(_that.stage,_that.startedAtMs,_that.durationMs,_that.ok,_that.reasons,_that.evidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EscalationStepDto extends EscalationStepDto {
  const _EscalationStepDto({this.stage = '', this.startedAtMs = 0, this.durationMs = 0, this.ok = false, this.reasons = const <String>[], this.evidence = const <String, String>{}}): super._();
  factory _EscalationStepDto.fromJson(Map<String, dynamic> json) => _$EscalationStepDtoFromJson(json);

@override@JsonKey() final  String stage;
@override@JsonKey() final  int startedAtMs;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  bool ok;
@override@JsonKey() final  List<String> reasons;
@override@JsonKey() final  Map<String, String> evidence;

/// Create a copy of EscalationStepDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationStepDtoCopyWith<_EscalationStepDto> get copyWith => __$EscalationStepDtoCopyWithImpl<_EscalationStepDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EscalationStepDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationStepDto&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stage,startedAtMs,durationMs,ok,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'EscalationStepDto(stage: $stage, startedAtMs: $startedAtMs, durationMs: $durationMs, ok: $ok, reasons: $reasons, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class _$EscalationStepDtoCopyWith<$Res> implements $EscalationStepDtoCopyWith<$Res> {
  factory _$EscalationStepDtoCopyWith(_EscalationStepDto value, $Res Function(_EscalationStepDto) _then) = __$EscalationStepDtoCopyWithImpl;
@override @useResult
$Res call({
 String stage, int startedAtMs, int durationMs, bool ok, List<String> reasons, Map<String, String> evidence
});




}
/// @nodoc
class __$EscalationStepDtoCopyWithImpl<$Res>
    implements _$EscalationStepDtoCopyWith<$Res> {
  __$EscalationStepDtoCopyWithImpl(this._self, this._then);

  final _EscalationStepDto _self;
  final $Res Function(_EscalationStepDto) _then;

/// Create a copy of EscalationStepDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? startedAtMs = null,Object? durationMs = null,Object? ok = null,Object? reasons = null,Object? evidence = null,}) {
  return _then(_EscalationStepDto(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<String>,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$EscalationRunDto {

 String get runId; String get chain; String get outcome; List<EscalationStepDto> get steps; int get startedAtMs; int get finishedAtMs; bool get residual;
/// Create a copy of EscalationRunDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EscalationRunDtoCopyWith<EscalationRunDto> get copyWith => _$EscalationRunDtoCopyWithImpl<EscalationRunDto>(this as EscalationRunDto, _$identity);

  /// Serializes this EscalationRunDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EscalationRunDto&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.finishedAtMs, finishedAtMs) || other.finishedAtMs == finishedAtMs)&&(identical(other.residual, residual) || other.residual == residual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,chain,outcome,const DeepCollectionEquality().hash(steps),startedAtMs,finishedAtMs,residual);

@override
String toString() {
  return 'EscalationRunDto(runId: $runId, chain: $chain, outcome: $outcome, steps: $steps, startedAtMs: $startedAtMs, finishedAtMs: $finishedAtMs, residual: $residual)';
}


}

/// @nodoc
abstract mixin class $EscalationRunDtoCopyWith<$Res>  {
  factory $EscalationRunDtoCopyWith(EscalationRunDto value, $Res Function(EscalationRunDto) _then) = _$EscalationRunDtoCopyWithImpl;
@useResult
$Res call({
 String runId, String chain, String outcome, List<EscalationStepDto> steps, int startedAtMs, int finishedAtMs, bool residual
});




}
/// @nodoc
class _$EscalationRunDtoCopyWithImpl<$Res>
    implements $EscalationRunDtoCopyWith<$Res> {
  _$EscalationRunDtoCopyWithImpl(this._self, this._then);

  final EscalationRunDto _self;
  final $Res Function(EscalationRunDto) _then;

/// Create a copy of EscalationRunDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? chain = null,Object? outcome = null,Object? steps = null,Object? startedAtMs = null,Object? finishedAtMs = null,Object? residual = null,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<EscalationStepDto>,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,finishedAtMs: null == finishedAtMs ? _self.finishedAtMs : finishedAtMs // ignore: cast_nullable_to_non_nullable
as int,residual: null == residual ? _self.residual : residual // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EscalationRunDto].
extension EscalationRunDtoPatterns on EscalationRunDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EscalationRunDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EscalationRunDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EscalationRunDto value)  $default,){
final _that = this;
switch (_that) {
case _EscalationRunDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EscalationRunDto value)?  $default,){
final _that = this;
switch (_that) {
case _EscalationRunDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  String chain,  String outcome,  List<EscalationStepDto> steps,  int startedAtMs,  int finishedAtMs,  bool residual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EscalationRunDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  String chain,  String outcome,  List<EscalationStepDto> steps,  int startedAtMs,  int finishedAtMs,  bool residual)  $default,) {final _that = this;
switch (_that) {
case _EscalationRunDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  String chain,  String outcome,  List<EscalationStepDto> steps,  int startedAtMs,  int finishedAtMs,  bool residual)?  $default,) {final _that = this;
switch (_that) {
case _EscalationRunDto() when $default != null:
return $default(_that.runId,_that.chain,_that.outcome,_that.steps,_that.startedAtMs,_that.finishedAtMs,_that.residual);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EscalationRunDto extends EscalationRunDto {
  const _EscalationRunDto({this.runId = '', this.chain = '', this.outcome = '', this.steps = const <EscalationStepDto>[], this.startedAtMs = 0, this.finishedAtMs = 0, this.residual = false}): super._();
  factory _EscalationRunDto.fromJson(Map<String, dynamic> json) => _$EscalationRunDtoFromJson(json);

@override@JsonKey() final  String runId;
@override@JsonKey() final  String chain;
@override@JsonKey() final  String outcome;
@override@JsonKey() final  List<EscalationStepDto> steps;
@override@JsonKey() final  int startedAtMs;
@override@JsonKey() final  int finishedAtMs;
@override@JsonKey() final  bool residual;

/// Create a copy of EscalationRunDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EscalationRunDtoCopyWith<_EscalationRunDto> get copyWith => __$EscalationRunDtoCopyWithImpl<_EscalationRunDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EscalationRunDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EscalationRunDto&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.finishedAtMs, finishedAtMs) || other.finishedAtMs == finishedAtMs)&&(identical(other.residual, residual) || other.residual == residual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,chain,outcome,const DeepCollectionEquality().hash(steps),startedAtMs,finishedAtMs,residual);

@override
String toString() {
  return 'EscalationRunDto(runId: $runId, chain: $chain, outcome: $outcome, steps: $steps, startedAtMs: $startedAtMs, finishedAtMs: $finishedAtMs, residual: $residual)';
}


}

/// @nodoc
abstract mixin class _$EscalationRunDtoCopyWith<$Res> implements $EscalationRunDtoCopyWith<$Res> {
  factory _$EscalationRunDtoCopyWith(_EscalationRunDto value, $Res Function(_EscalationRunDto) _then) = __$EscalationRunDtoCopyWithImpl;
@override @useResult
$Res call({
 String runId, String chain, String outcome, List<EscalationStepDto> steps, int startedAtMs, int finishedAtMs, bool residual
});




}
/// @nodoc
class __$EscalationRunDtoCopyWithImpl<$Res>
    implements _$EscalationRunDtoCopyWith<$Res> {
  __$EscalationRunDtoCopyWithImpl(this._self, this._then);

  final _EscalationRunDto _self;
  final $Res Function(_EscalationRunDto) _then;

/// Create a copy of EscalationRunDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? chain = null,Object? outcome = null,Object? steps = null,Object? startedAtMs = null,Object? finishedAtMs = null,Object? residual = null,}) {
  return _then(_EscalationRunDto(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<EscalationStepDto>,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,finishedAtMs: null == finishedAtMs ? _self.finishedAtMs : finishedAtMs // ignore: cast_nullable_to_non_nullable
as int,residual: null == residual ? _self.residual : residual // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
