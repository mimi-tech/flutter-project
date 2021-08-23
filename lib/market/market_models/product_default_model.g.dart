// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_default_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDefaultModel _$ProductDefaultModelFromJson(Map<String, dynamic> json) {
  return ProductDefaultModel(
    cmId: json['cmId'] as String?,
    prImg: (json['prImg'] as List<dynamic>?)?.map((e) => e as String).toList(),
    price: (json['price'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$ProductDefaultModelToJson(
        ProductDefaultModel instance) =>
    <String, dynamic>{
      'cmId': instance.cmId,
      'prImg': instance.prImg,
      'price': instance.price,
    };
