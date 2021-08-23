// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth_product_listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothProductListingModel _$ClothProductListingModelFromJson(
    Map<String, dynamic> json) {
  return ClothProductListingModel(
    id: json['id'] as String?,
    docId: json['docId'] as String?,
    cmId: json['cmId'] as String?,
    sku: json['sku'] as String?,
    prC: json['prC'] as String?,
    subC: json['subC'] as String?,
    cCol: json['cCol'] as int?,
    cond: json['cond'] as String?,
    cSize: json['cSize'] as String?,
    mat: json['mat'] as String?,
    mfac: json['mfac'] as String?,
    prB: json['prB'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    pDes: json['pDes'] as String?,
    pIdC: json['pIdC'] as String?,
    prN: json['prN'] as String?,
    prImg: (json['prImg'] as List<dynamic>?)?.map((e) => e as String).toList(),
    pIdTp: json['pIdTp'] as String?,
    qty: json['qty'] as int?,
    stock: json['stock'] as int?,
    sdCnt: json['sdCnt'] as int?,
    isFirst: json['isFirst'] as bool?,
    ts: json['ts'] as int?,
  );
}

Map<String, dynamic> _$ClothProductListingModelToJson(
        ClothProductListingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'docId': instance.docId,
      'cmId': instance.cmId,
      'sku': instance.sku,
      'cond': instance.cond,
      'prC': instance.prC,
      'subC': instance.subC,
      'cSize': instance.cSize,
      'cCol': instance.cCol,
      'mat': instance.mat,
      'qty': instance.qty,
      'stock': instance.stock,
      'pIdTp': instance.pIdTp,
      'pIdC': instance.pIdC,
      'prN': instance.prN,
      'prB': instance.prB,
      'mfac': instance.mfac,
      'price': instance.price,
      'pDes': instance.pDes,
      'sdCnt': instance.sdCnt,
      'isFirst': instance.isFirst,
      'ts': instance.ts,
      'prImg': instance.prImg,
    };
