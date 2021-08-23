import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloth_base_model.g.dart';

@JsonSerializable()
class ClothBaseModel {
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
  int? rtC;

  /// Product rating
  double? rate;

  /// Product review count
  int? rvC;

  /// Product price
  double? price;

  /// Product sold count
  int? sdCnt;

  /// Cloth sub department
  String? subC;

  /// Cloth sizes
  Map<String, bool>? cSize;

  /// Search key words
  List<String>? sWords;

  ClothBaseModel({
    required this.id,
    required this.cmId,
    required this.docId,
    required this.prN,
    required this.cond,
    required this.prC,
    required this.prImg,
    required this.rtC,
    required this.rate,
    required this.rvC,
    required this.price,
    required this.sdCnt,
    required this.subC,
    required this.cSize,
    required this.sWords,
  });

  factory ClothBaseModel.fromJson(Map<String, dynamic> json) =>
      _$ClothBaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClothBaseModelToJson(this);
}
