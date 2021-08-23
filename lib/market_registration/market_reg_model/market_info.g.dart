// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketInfo _$MarketInfoFromJson(Map<String, dynamic> json) {
  return MarketInfo(
    id: json['id'] as String?,
    un: json['un'] as String?,
    em: json['em'] as String?,
    emv: json['emv'] as bool?,
  );
}

Map<String, dynamic> _$MarketInfoToJson(MarketInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'un': instance.un,
      'em': instance.em,
      'emv': instance.emv,
    };
