// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'displayed_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayedProductModel _$DisplayedProductModelFromJson(
    Map<String, dynamic> json) {
  return DisplayedProductModel(
    storeDetailsModel: json['storeDetailsModel'] == null
        ? null
        : StoreDetailsModel.fromJson(
            json['storeDetailsModel'] as Map<String, dynamic>),
    productHomeDetailModel: json['productHomeDetailModel'] == null
        ? null
        : ProductHomeDetailModel.fromJson(
            json['productHomeDetailModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DisplayedProductModelToJson(
        DisplayedProductModel instance) =>
    <String, dynamic>{
      'storeDetailsModel': instance.storeDetailsModel?.toJson(),
      'productHomeDetailModel': instance.productHomeDetailModel?.toJson(),
    };
