// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_spark_up_mm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSparkUpMM _$CreateSparkUpMMFromJson(Map<String, dynamic> json) {
  return CreateSparkUpMM(
    sid: json['sid'] as String?,
    recId: json['recId'] as String?,
    stsT: json['stsT'] as String?,
    reqSt:
        json['reqSt'] == null ? null : DateTime.parse(json['reqSt'] as String),
    reqCom: json['reqCom'] == null
        ? null
        : DateTime.parse(json['reqCom'] as String),
    sUpTy: json['sUpTy'] as String?,
    asA: json['asA'] as String?,
    meId: json['meId'] as String?,
    nm: (json['nm'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String?),
    ),
    em: json['em'] as String?,
    pimg: json['pimg'] as String?,
  );
}

Map<String, dynamic> _$CreateSparkUpMMToJson(CreateSparkUpMM instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'recId': instance.recId,
      'stsT': instance.stsT,
      'reqSt': instance.reqSt?.toIso8601String(),
      'reqCom': instance.reqCom?.toIso8601String(),
      'sUpTy': instance.sUpTy,
      'asA': instance.asA,
      'meId': instance.meId,
      'em': instance.em,
      'nm': instance.nm,
      'pimg': instance.pimg,
    };
