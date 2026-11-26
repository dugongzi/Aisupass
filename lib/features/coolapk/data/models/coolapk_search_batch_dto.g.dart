// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_search_batch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoolapkSearchBatchDto _$CoolapkSearchBatchDtoFromJson(
  Map<String, dynamic> json,
) => _CoolapkSearchBatchDto(
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => CoolapkSearchResultDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CoolapkSearchResultDto>[],
);

Map<String, dynamic> _$CoolapkSearchBatchDtoToJson(
  _CoolapkSearchBatchDto instance,
) => <String, dynamic>{'data': instance.data};
