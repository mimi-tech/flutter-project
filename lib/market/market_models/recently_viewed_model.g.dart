// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_viewed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentlyViewedModel _$RecentlyViewedModelFromJson(Map<String, dynamic> json) {
  return RecentlyViewedModel(
    id: json['id'] as String?,
    cmId: json['cmId'] as String?,
    cond: json['cond'] as String?,
    prC: json['prC'] as String?,
    prImg: json['prImg'] as String?,
    prN: json['prN'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    docId: json['docId'] as String?,
    ts: json['ts'] as int?,
  );
}

Map<String, dynamic> _$RecentlyViewedModelToJson(
        RecentlyViewedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cmId': instance.cmId,
      'cond': instance.cond,
      'prC': instance.prC,
      'prImg': instance.prImg,
      'prN': instance.prN,
      'price': instance.price,
      'docId': instance.docId,
      'ts': instance.ts,
    };
