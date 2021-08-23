// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sparks_user_general.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SparksUserGeneral _$SparksUserGeneralFromJson(Map<String, dynamic> json) {
  return SparksUserGeneral(
    acct: (json['acct'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    phne: (json['phne'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    tkn: json['tkn'] as String?,
    sts: json['sts'] as String?,
    ol: json['ol'] as bool?,
    em: json['em'] as String?,
    emv: json['emv'] as bool?,
  );
}

Map<String, dynamic> _$SparksUserGeneralToJson(SparksUserGeneral instance) =>
    <String, dynamic>{
      'acct': instance.acct,
      'phne': instance.phne,
      'tkn': instance.tkn,
      'sts': instance.sts,
      'ol': instance.ol,
      'em': instance.em,
      'emv': instance.emv,
    };
