import 'package:json_annotation/json_annotation.dart';

part 'product_default_model.g.dart';

@JsonSerializable()
class ProductDefaultModel {
  String? cmId; // Common Id

  List<String>? prImg; // Product Images

  double? price; // Product price

  ProductDefaultModel({this.cmId, this.prImg, this.price});

  factory ProductDefaultModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDefaultModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDefaultModelToJson(this);
}
