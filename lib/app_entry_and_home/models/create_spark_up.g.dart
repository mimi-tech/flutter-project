// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_spark_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSparkUp _$CreateSparkUpFromJson(Map<String, dynamic> json) {
  return CreateSparkUp(
    sid: json['sid'] as String?,
    reqTo: json['reqTo'] as String?,
    stsT: json['stsT'] as String?,
    reqSt:
        json['reqSt'] == null ? null : DateTime.parse(json['reqSt'] as String),
    reqCom: json['reqCom'] == null
        ? null
        : DateTime.parse(json['reqCom'] as String),
    sUpTy: json['sUpTy'] as String?,
    fId: json['fId'] as String?,
    nm: (json['nm'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String?),
    ),
    em: json['em'] as String?,
    pimg: json['pimg'] as String?,
  );
}

Map<String, dynamic> _$CreateSparkUpToJson(CreateSparkUp instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'reqTo': instance.reqTo,
      'stsT': instance.stsT,
      'reqSt': instance.reqSt?.toIso8601String(),
      'reqCom': instance.reqCom?.toIso8601String(),
      'sUpTy': instance.sUpTy,
      'fId': instance.fId,
      'em': instance.em,
      'nm': instance.nm,
      'pimg': instance.pimg,
    };
