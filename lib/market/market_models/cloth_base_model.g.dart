// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth_base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothBaseModel _$ClothBaseModelFromJson(Map<String, dynamic> json) {
  return ClothBaseModel(
    id: json['id'] as String?,
    cmId: json['cmId'] as String?,
    docId: json['docId'] as String?,
    prN: json['prN'] as String?,
    cond: json['cond'] as String?,
    prC: json['prC'] as String?,
    prImg: (json['prImg'] as List<dynamic>?)?.map((e) => e as String).toList(),
    rtC: json['rtC'] as int?,
    rate: (json['rate'] as num?)?.toDouble(),
    rvC: json['rvC'] as int?,
    price: (json['price'] as num?)?.toDouble(),
    sdCnt: json['sdCnt'] as int?,
    subC: json['subC'] as String?,
    cSize: (json['cSize'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as bool),
    ),
    sWords:
        (json['sWords'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ClothBaseModelToJson(ClothBaseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cmId': instance.cmId,
      'docId': instance.docId,
      'prN': instance.prN,
      'cond': instance.cond,
      'prC': instance.prC,
      'prImg': instance.prImg,
      'rtC': instance.rtC,
      'rate': instance.rate,
      'rvC': instance.rvC,
      'price': instance.price,
      'sdCnt': instance.sdCnt,
      'subC': instance.subC,
      'cSize': instance.cSize,
      'sWords': instance.sWords,
    };
