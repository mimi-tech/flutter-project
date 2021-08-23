// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimilarProductModel _$SimilarProductModelFromJson(Map<String, dynamic> json) {
  return SimilarProductModel(
    cmId: json['cmId'] as String?,
    id: json['id'] as String?,
    prN: json['prN'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    rate: (json['rate'] as num?)?.toDouble(),
    cond: json['cond'] as String?,
    prC: json['prC'] as String?,
    prImg: (json['prImg'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$SimilarProductModelToJson(
        SimilarProductModel instance) =>
    <String, dynamic>{
      'cmId': instance.cmId,
      'id': instance.id,
      'prN': instance.prN,
      'price': instance.price,
      'rate': instance.rate,
      'cond': instance.cond,
      'prC': instance.prC,
      'prImg': instance.prImg,
    };
