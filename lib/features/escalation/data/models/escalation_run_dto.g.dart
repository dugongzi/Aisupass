// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_run_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EscalationStepDto _$EscalationStepDtoFromJson(Map<String, dynamic> json) =>
    _EscalationStepDto(
      stage: json['stage'] as String? ?? '',
      startedAtMs: (json['startedAtMs'] as num?)?.toInt() ?? 0,
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
      ok: json['ok'] as bool? ?? false,
      reasons:
          (json['reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      evidence:
          (json['evidence'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$EscalationStepDtoToJson(_EscalationStepDto instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'startedAtMs': instance.startedAtMs,
      'durationMs': instance.durationMs,
      'ok': instance.ok,
      'reasons': instance.reasons,
      'evidence': instance.evidence,
    };

_EscalationRunDto _$EscalationRunDtoFromJson(Map<String, dynamic> json) =>
    _EscalationRunDto(
      runId: json['runId'] as String? ?? '',
      chain: json['chain'] as String? ?? '',
      outcome: json['outcome'] as String? ?? '',
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map(
                (e) => EscalationStepDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <EscalationStepDto>[],
      startedAtMs: (json['startedAtMs'] as num?)?.toInt() ?? 0,
      finishedAtMs: (json['finishedAtMs'] as num?)?.toInt() ?? 0,
      residual: json['residual'] as bool? ?? false,
    );

Map<String, dynamic> _$EscalationRunDtoToJson(_EscalationRunDto instance) =>
    <String, dynamic>{
      'runId': instance.runId,
      'chain': instance.chain,
      'outcome': instance.outcome,
      'steps': instance.steps,
      'startedAtMs': instance.startedAtMs,
      'finishedAtMs': instance.finishedAtMs,
      'residual': instance.residual,
    };
