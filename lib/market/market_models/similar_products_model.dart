import 'package:json_annotation/json_annotation.dart';

part 'similar_products_model.g.dart';

@JsonSerializable()
class SimilarProductModel {
  /// Common ID
  String? cmId;

  /// Store ID
  String? id;

  /// Product name
  String? prN;

  /// Product price
  double? price;

  /// Product rating
  double? rate;

  /// Product condition
  String? cond;

  /// Product category
  String? prC;

  /// Image url
  List<String>? prImg;

  SimilarProductModel({
    this.cmId,
    this.id,
    this.prN,
    this.price,
    this.rate,
    this.cond,
    this.prC,
    this.prImg,
  });

  factory SimilarProductModel.fromJson(Map<String, dynamic> json) =>
      _$SimilarProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$SimilarProductModelToJson(this);
}
