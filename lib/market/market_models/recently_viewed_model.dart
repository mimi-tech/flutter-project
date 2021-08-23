import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recently_viewed_model.g.dart';

@JsonSerializable()
class RecentlyViewedModel {
  /// Store uid
  String? id;

  /// Common Id
  String? cmId;

  /// Product condition
  String? cond;

  /// Product category
  String? prC;

  /// Image URL String
  String? prImg;

  /// Product Name
  String? prN;

  /// Product Price
  double? price;

  /// Recently Viewed Id
  String? docId;

  /// TimeStamp
  int? ts;

  RecentlyViewedModel({
    required this.id,
    required this.cmId,
    required this.cond,
    required this.prC,
    required this.prImg,
    required this.prN,
    required this.price,
    required this.docId,
    required this.ts,
  });

  factory RecentlyViewedModel.fromJson(Map<String, dynamic> json) =>
      _$RecentlyViewedModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecentlyViewedModelToJson(this);
}
