import 'package:json_annotation/json_annotation.dart';

part 'cloth_product_listing_model.g.dart';

@JsonSerializable()
class ClothProductListingModel {
  /// user UID
  String? id;

  /// Document Reference Id
  String? docId;

  /// common id
  String? cmId;

  /// sparks sku
  String? sku;

  /// condition
  String? cond;

  /// product category
  String? prC;

  /// product department OR sub-category
  String? subC;

  /// cloth size
  String? cSize;

  /// cloth color
  int? cCol;

  /// material
  String? mat;

  /// quantity
  int? qty;

  /// number of available product
  int? stock;

  /// product Id type
  String? pIdTp;

  /// product id code
  String? pIdC;

  /// product name
  String? prN;

  /// product brand
  String? prB;

  /// manufacturer
  String? mfac;

  /// price
  double? price;

  /// product description
  String? pDes;

  /// sold count
  int? sdCnt;

  /// first product variation
  bool? isFirst;

  int? ts;

  /// product images
  List<String>? prImg;

  ClothProductListingModel({
    this.id,
    this.docId,
    this.cmId,
    this.sku,
    this.prC,
    this.subC,
    this.cCol,
    this.cond,
    this.cSize,
    this.mat,
    this.mfac,
    this.prB,
    this.price,
    this.pDes,
    this.pIdC,
    this.prN,
    this.prImg,
    this.pIdTp,
    this.qty,
    this.stock,
    this.sdCnt,
    @JsonKey(defaultValue: false) this.isFirst,
    this.ts,
  });

  factory ClothProductListingModel.fromJson(Map<String, dynamic> json) =>
      _$ClothProductListingModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClothProductListingModelToJson(this);
}
