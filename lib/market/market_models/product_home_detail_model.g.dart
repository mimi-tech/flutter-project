// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_home_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductHomeDetailModel _$ProductHomeDetailModelFromJson(
    Map<String, dynamic> json) {
  return ProductHomeDetailModel(
    id: json['id'] as String?,
    cmId: json['cmId'] as String?,
    docId: json['docId'] as String?,
    prN: json['prN'] as String?,
    cond: json['cond'] as String?,
    prC: json['prC'] as String?,
    prImg: (json['prImg'] as List<dynamic>?)?.map((e) => e as String).toList(),
    rtC: json['rtC'] as int? ?? 0,
    rate: (json['rate'] as num?)?.toDouble() ?? 0,
    rvC: json['rvC'] as int? ?? 0,
    price: (json['price'] as num?)?.toDouble(),
    sdCnt: json['sdCnt'] as int? ?? 0,
    sWords:
        (json['sWords'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ProductHomeDetailModelToJson(
        ProductHomeDetailModel instance) =>
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
      'sWords': instance.sWords,
    };
