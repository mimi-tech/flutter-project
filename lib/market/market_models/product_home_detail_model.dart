import 'package:json_annotation/json_annotation.dart';

part 'product_home_detail_model.g.dart';

@JsonSerializable()
class ProductHomeDetailModel {
  /// Store uid
  String? id;

  /// Common Id
  String? cmId;

  /// Document Id
  String? docId;

  /// Product name
  String? prN;

  /// Product condition
  String? cond;

  /// Product category
  String? prC;

  /// Product Images
  List<String>? prImg;

  /// Product rating count
  @JsonKey(defaultValue: 0)
  int? rtC;

  /// Product rating
  @JsonKey(defaultValue: 0)
  double? rate;

  /// Product review count
  @JsonKey(defaultValue: 0)
  int? rvC;

  /// Product price
  double? price;

  /// Product sold count
  @JsonKey(defaultValue: 0)
  int? sdCnt;

  /// Search key words
  List<String>? sWords;

  ProductHomeDetailModel({
    this.id,
    this.cmId,
    this.docId,
    this.prN,
    this.cond,
    this.prC,
    this.prImg,
    this.rtC,
    this.rate,
    this.rvC,
    this.price,
    this.sdCnt,
    this.sWords,
  });

  factory ProductHomeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProductHomeDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductHomeDetailModelToJson(this);
}
