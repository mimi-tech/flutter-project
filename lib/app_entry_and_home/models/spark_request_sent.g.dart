// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spark_request_sent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SparksRequestSent _$SparksRequestSentFromJson(Map<String, dynamic> json) {
  return SparksRequestSent(
    id: json['id'] as String?,
    rType: json['rType'] as String?,
    rSent:
        json['rSent'] == null ? null : DateTime.parse(json['rSent'] as String),
  );
}

Map<String, dynamic> _$SparksRequestSentToJson(SparksRequestSent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rType': instance.rType,
      'rSent': instance.rSent?.toIso8601String(),
    };
