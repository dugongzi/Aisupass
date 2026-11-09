// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dirty_frag_outcome_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DirtyFragOutcomeDto _$DirtyFragOutcomeDtoFromJson(Map<String, dynamic> json) =>
    _DirtyFragOutcomeDto(
      sessionId: json['sessionId'] as String? ?? '',
      output: json['output'] as String? ?? '',
      exitCode: (json['exitCode'] as num?)?.toInt() ?? -1,
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
      timedOut: json['timedOut'] as bool? ?? false,
      resolvedVrOffset: json['resolvedVrOffset'] as String? ?? '',
      failure: json['failure'] as String? ?? '',
      kind:
          $enumDecodeNullable(_$DirtyFragKindEnumMap, json['kind']) ??
          DirtyFragKind.running,
      log: json['log'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );

Map<String, dynamic> _$DirtyFragOutcomeDtoToJson(
  _DirtyFragOutcomeDto instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'output': instance.output,
  'exitCode': instance.exitCode,
  'durationMs': instance.durationMs,
  'timedOut': instance.timedOut,
  'resolvedVrOffset': instance.resolvedVrOffset,
  'failure': instance.failure,
  'kind': _$DirtyFragKindEnumMap[instance.kind]!,
  'log': instance.log,
  'reason': instance.reason,
};

const _$DirtyFragKindEnumMap = {
  DirtyFragKind.running: 'running',
  DirtyFragKind.notStarted: 'notStarted',
  DirtyFragKind.succeeded: 'succeeded',
  DirtyFragKind.notVulnerable: 'notVulnerable',
  DirtyFragKind.patchFailed: 'patchFailed',
  DirtyFragKind.vrFailed: 'vrFailed',
  DirtyFragKind.bootstrapFailed: 'bootstrapFailed',
  DirtyFragKind.timedOut: 'timedOut',
  DirtyFragKind.failed: 'failed',
};
