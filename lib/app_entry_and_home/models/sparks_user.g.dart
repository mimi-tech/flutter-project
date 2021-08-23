// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sparks_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SparksUser _$SparksUserFromJson(Map<String, dynamic> json) {
  return SparksUser(
    id: json['id'] as String?,
    nm: (json['nm'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String?),
    ),
    pimg: json['pimg'] as String?,
    addr: json['addr'] as Map<String, dynamic>?,
    bdate: json['bdate'] as String?,
    sex: json['sex'] as String?,
    marst: json['marst'] as String?,
    lang: (json['lang'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    hobb: (json['hobb'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    aoi: (json['aoi'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    ind: (json['ind'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    spec: (json['spec'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    schVt: json['schVt'] as bool?,
    isMen: json['isMen'] as bool?,
    un: json['un'] as String?,
    em: json['em'] as String?,
    emv: json['emv'] as bool?,
    crAt: json['crAt'] == null ? null : DateTime.parse(json['crAt'] as String),
  );
}

Map<String, dynamic> _$SparksUserToJson(SparksUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nm': instance.nm,
      'pimg': instance.pimg,
      'addr': instance.addr,
      'bdate': instance.bdate,
      'sex': instance.sex,
      'marst': instance.marst,
      'lang': instance.lang,
      'hobb': instance.hobb,
      'aoi': instance.aoi,
      'ind': instance.ind,
      'spec': instance.spec,
      'schVt': instance.schVt,
      'isMen': instance.isMen,
      'un': instance.un,
      'em': instance.em,
      'emv': instance.emv,
      'crAt': instance.crAt?.toIso8601String(),
    };
